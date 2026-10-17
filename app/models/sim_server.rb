class SimServer < ApplicationRecord
  belongs_to :track, optional: true

  validates :name, :server_ip, :track_name, presence: true

  def join_url
    cm_join_link.presence || "acmanager://race/online/join?ip=#{server_ip}&httpPort=#{http_port}"
  end

  def occupancy_percent
    return 0 if capacity.to_i.zero?
    ((online_drivers.to_f / capacity) * 100).round
  end
end
