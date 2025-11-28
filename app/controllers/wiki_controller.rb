class WikiController < ApplicationController
  def index
  end

  def ask
    # Handle both JSON and form data
    question = params[:question] || JSON.parse(request.body.read)['question']
    
    if question.blank?
      render json: { error: 'Вопрос не может быть пустым' }, status: :bad_request
      return
    end

    begin
      answer = GeminiService.get_racing_advice(question)
      render json: { answer: answer }
    rescue => e
      Rails.logger.error "Gemini Service Error: #{e.message}"
      render json: { error: 'Ошибка связи с AI сервисом' }, status: :internal_server_error
    end
  end
end
