# frozen_string_literal: true

namespace :events do
  desc "Sync events from external autodrome calendars. Optional SOURCE=nring,igora"
  task sync: :environment do
    sources = ENV["SOURCE"]&.split(",")&.map(&:strip)&.reject(&:blank?)
    results = EventSync::Runner.new(sources: sources).call

    results.each do |r|
      if r.error
        puts "#{r.source}: ERROR — #{r.error}"
      else
        u = r.upsert
        puts "#{r.source}: fetched=#{r.fetched} created=#{u.created} updated=#{u.updated} cancelled=#{u.cancelled} skipped=#{u.skipped}"
      end
    end

    abort "One or more sources failed" if results.any?(&:error)
  end
end
