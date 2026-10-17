class SimulatorSlot < ApplicationRecord
  has_many :sim_bookings, dependent: :destroy

  validates :name, :hourly_rate_rub, presence: true

  scope :active, -> { where(active: true) }
end
