class ChampionshipsController < ApplicationController
  def index
    @championships = Championship.active.includes(:championship_seasons)
  end

  def show
    @championship = Championship.find_by!(slug: params[:slug])
    @season = @championship.championship_seasons.latest.first
    @stages = @season ? @season.championship_stages.includes(:track).ordered : []
    @standings = @season ? @season.championship_standings.includes(:pilot, :team).ordered : []
    @classes = @standings.map(&:racing_class).uniq
  end
end
