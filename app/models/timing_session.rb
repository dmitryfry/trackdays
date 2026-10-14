class TimingSession < ApplicationRecord
  belongs_to :track
  belongs_to :event, optional: true
  has_many :lap_results, dependent: :destroy

  validates :name, presence: true
  validates :status, inclusion: { in: %w[live finished scheduled] }

  scope :live_now, -> { where(status: "live").order(started_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
end
