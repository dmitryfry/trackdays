class PilotsController < ApplicationController
  def index
    @pilots = Pilot.top_ranked.includes(:team)
  end

  def show
    @pilot = Pilot.includes(:team, :lap_results, :gps_dyno_runs, championship_standings: { championship_season: :championship }).find(params[:id])
    @best_laps = @pilot.lap_results.valid_laps.fastest_first.limit(5)
  end
end
