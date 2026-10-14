class TeamsController < ApplicationController
  def index
    @teams = Team.order(points: :desc)
  end

  def show
    @team = Team.includes(:pilots, championship_standings: { championship_season: :championship }).find_by!(slug: params[:slug])
  end
end
