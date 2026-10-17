class SimLapRecord < ApplicationRecord
  belongs_to :pilot, optional: true
  belongs_to :track, optional: true

  validates :driver_name, :car_name, :lap_time, :record_date, presence: true

  scope :leaderboard, -> { order(lap_time: :asc) }

  def formatted_lap_time
    total_seconds = lap_time.to_f
    minutes = (total_seconds / 60).to_i
    seconds = (total_seconds % 60).round(3)
    format("%02d:%06.3f", minutes, seconds)
  end
end
