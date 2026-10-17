class SimracingController < ApplicationController
  def servers
    @servers = SimServer.where(status: ["online", "maintenance"]).order(online_drivers: :desc)
    @tracks = Track.all
  end

  def leaderboard
    @records = SimLapRecord.includes(:pilot, :track).leaderboard
    @records = @records.where(track_id: params[:track_id]) if params[:track_id].present?
    @records = @records.where("car_name ILIKE ?", "%#{params[:car]}%") if params[:car].present?
    @tracks = Track.all
  end

  def mods
    @mods = SimMod.order(created_at: :desc)
    @mods = @mods.where(mod_type: params[:type]) if params[:type].present?
  end
end
