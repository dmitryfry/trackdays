class GpsDynoRun < ApplicationRecord
  belongs_to :pilot, optional: true

  validates :title, presence: true
  validates :car_model, presence: true
  validates :car_mass_kg, presence: true, numericality: { greater_than: 0 }
  validates :calculated_hp, presence: true, numericality: { greater_than: 0 }
  validates :calculated_torque_nm, presence: true, numericality: { greater_than: 0 }

  scope :top_power, -> { order(calculated_hp: :desc) }
  scope :recent, -> { order(created_at: :desc) }
end
