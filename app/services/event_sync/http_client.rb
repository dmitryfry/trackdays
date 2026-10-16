# frozen_string_literal: true

require "net/http"
require "uri"

module EventSync
  class HttpClient
    USER_AGENT = "TrackDays.ru calendar-sync (+https://trackdays.ru; contact@trackdays.ru)"
    DEFAULT_TIMEOUT = 20
    MAX_RETRIES = 2
    HOST_PAUSE = 1.5

    class Error < StandardError; end

    def initialize(timeout: DEFAULT_TIMEOUT, pause: HOST_PAUSE)
      @timeout = timeout
      @pause = pause
      @last_host_at = {}
    end

    def get(url, headers: {})
      uri = URI(url)
      throttle!(uri.host)

      response = request_with_retries(uri, headers)

      case response
      when Net::HTTPSuccess
        response.body.force_encoding("UTF-8")
      when Net::HTTPRedirection
        location = response["location"]
        raise Error, "Redirect without location from #{url}" if location.blank?

        next_url = URI.join(url, location).to_s
        get(next_url, headers: headers)
      else
        raise Error, "HTTP #{response.code} for #{url}"
      end
    end

    private

    def throttle!(host)
      last = @last_host_at[host]
      if last
        wait = @pause - (Process.clock_gettime(Process::CLOCK_MONOTONIC) - last)
        sleep(wait) if wait.positive?
      end
      @last_host_at[host] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def request_with_retries(uri, headers)
      attempts = 0
      loop do
        attempts += 1
        begin
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == "https"
          http.open_timeout = @timeout
          http.read_timeout = @timeout

          request = Net::HTTP::Get.new(uri)
          request["User-Agent"] = USER_AGENT
          request["Accept"] = "text/html,application/xhtml+xml,application/json;q=0.9,*/*;q=0.8"
          headers.each { |k, v| request[k] = v }

          response = http.request(request)

          retryable = response.is_a?(Net::HTTPTooManyRequests) || response.code.to_i >= 500
          if retryable && attempts <= MAX_RETRIES
            sleep(attempts * 2)
            next
          end

          return response
        rescue Timeout::Error, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError => e
          raise Error, e.message if attempts > MAX_RETRIES

          sleep(attempts * 2)
        end
      end
    end
  end
end
