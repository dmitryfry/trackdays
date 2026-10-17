class GarageCar < ApplicationRecord
  belongs_to :pilot, optional: true
  has_many :logbook_entries, dependent: :destroy
  has_many :market_listings, dependent: :nullify

  validates :make, :model, presence: true

  before_save :calculate_weight_power_ratio

  scope :car_of_the_week, -> { where(car_of_the_week: true) }
  scope :for_rent, -> { where(for_rent: true) }
  scope :by_class, ->(klass) { where(car_class: klass) if klass.present? }
  scope :with_onboards, -> { joins(:logbook_entries).where.not(logbook_entries: { onboard_video_url: [nil, ""] }).distinct }

  def display_name
    "#{make} #{model} #{year}".strip
  end

  def best_lap_time
    pilot&.best_lap
  end

  def latest_gps_dyno
    pilot&.gps_dyno_runs&.order(run_date: :desc)&.first
  end

  private

  def calculate_weight_power_ratio
    if mass_kg.present? && power_hp.present? && power_hp.positive?
      self.weight_power_ratio = (mass_kg / power_hp.to_f).round(2)
    end
  end
end
