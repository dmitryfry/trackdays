require 'net/http'
require 'json'
require 'uri'

class GeminiService
  API_KEY = ENV['GEMINI_API_KEY'] || ''
  API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent'

  def self.get_racing_advice(user_question)
    return "API Key не настроен. Пожалуйста, проверьте переменные окружения." if API_KEY.blank?

    uri = URI("#{API_URL}?key=#{API_KEY}")
    
    request_body = {
      contents: [{
        parts: [{
          text: user_question
        }]
      }],
      systemInstruction: {
        parts: [{
          text: "Ты эксперт профессиональный тренер и инженер по автоспорту. 
          Ты специализируешься на трек-днях, настройке автомобилей, гоночных траекториях и технике вождения (торможение, апекс, выход). 
          Ты полезен, ободряешь и технически точен. 
          Отвечай на русском языке. Держи ответы краткими (до 200 слов), но информативными.
          Если вопрос о безопасности, приоритет безопасности прежде всего."
        }]
      }
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = request_body.to_json

    response = http.request(request)
    
    if response.code == '200'
      data = JSON.parse(response.body)
      data.dig('candidates', 0, 'content', 'parts', 0, 'text') || "Извините, не удалось получить совет тренера прямо сейчас."
    else
      Rails.logger.error "Gemini API Error: #{response.code} - #{response.body}"
      "Ошибка связи с пит-лейном (AI service error)."
    end
  rescue => e
    Rails.logger.error "Gemini Service Error: #{e.message}"
    "Ошибка связи с пит-лейном (AI service error)."
  end
end

