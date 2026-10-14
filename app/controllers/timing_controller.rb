class TimingController < ApplicationController
  def index
    @live_sessions = TimingSession.includes(:track).live_now
    @recent_sessions = TimingSession.includes(:track).where.not(status: "live").recent.limit(10)
    @tracks = Track.all
  end

  def show
    @session = TimingSession.includes(:track, lap_results: :pilot).find(params[:id])
    @lap_results = @session.lap_results.order(lap_time: :asc)
    
    # Calculate best sectors across the whole session
    @best_s1 = @lap_results.where.not(sector_1_time: nil).minimum(:sector_1_time)
    @best_s2 = @lap_results.where.not(sector_2_time: nil).minimum(:sector_2_time)
    @best_s3 = @lap_results.where.not(sector_3_time: nil).minimum(:sector_3_time)
  end

  def live_feed
    @session = TimingSession.includes(lap_results: :pilot).find(params[:id])
    results = @session.lap_results.order(lap_time: :asc).map do |r|
      {
        id: r.id,
        pilot_name: r.pilot.name,
        car: r.pilot.car,
        lap_time: r.formatted_lap_time,
        s1: r.sector_1_time,
        s2: r.sector_2_time,
        s3: r.sector_3_time,
        top_speed: r.top_speed,
        gap: r.gap,
        is_valid: r.is_valid
      }
    end

    render json: {
      session_id: @session.id,
      status: @session.status,
      timestamp: Time.current.to_i,
      results: results
    }
  end
end
