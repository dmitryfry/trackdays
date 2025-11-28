class ResultsController < ApplicationController
  def index
    @pilot = Pilot.first || Pilot.new(name: 'Алексей Петров', car: 'Subaru WRX STI', pilot_class: 'Sport', best_lap: '1:54.320')
    @event = Event.first
    @lap_results = @pilot.persisted? && @event ? @pilot.lap_results.where(event: @event).order(:session) : []
    
    # Mock data if no real data exists
    if @lap_results.empty? && @event
      @lap_results = [
        OpenStruct.new(session: 1, lap_time: 125.5, is_valid: true),
        OpenStruct.new(session: 2, lap_time: 122.1, is_valid: true),
        OpenStruct.new(session: 3, lap_time: 120.4, is_valid: true),
        OpenStruct.new(session: 4, lap_time: 118.8, is_valid: false),
        OpenStruct.new(session: 5, lap_time: 114.3, is_valid: true),
      ]
    end
  end
end
