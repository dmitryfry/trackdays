class LapResult < ApplicationRecord
  belongs_to :event, optional: true
  belongs_to :pilot
  belongs_to :timing_session, optional: true

  scope :valid_laps, -> { where(is_valid: true) }
  scope :fastest_first, -> { order(lap_time: :asc) }

  def formatted_lap_time
    return "-" if lap_time.blank?
    mins = (lap_time / 60).to_i
    secs = (lap_time % 60).round(3)
    sprintf("%d:%06.3f", mins, secs)
  end
end
