class SimBooking < ApplicationRecord
  belongs_to :simulator_slot
  belongs_to :pilot, optional: true

  validates :customer_name, :customer_phone, :booking_date, :time_slot, presence: true

  before_validation :compute_total_price

  private

  def compute_total_price
    base = (simulator_slot&.hourly_rate_rub || 1500) * (duration_hours || 1)
    instructor_fee = with_instructor ? 1000 * (duration_hours || 1) : 0
    self.total_price_rub = base + instructor_fee
  end
end
