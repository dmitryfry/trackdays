class Event < ApplicationRecord
  belongs_to :track
  has_many :lap_results, dependent: :destroy

  KINDS = %w[track_day sport other].freeze
  STATUSES = %w[scheduled cancelled completed].freeze

  validates :kind, inclusion: { in: KINDS }
  validates :status, inclusion: { in: STATUSES }
  validates :external_id, uniqueness: { scope: :source }, allow_nil: true

  scope :scheduled, -> { where(status: "scheduled") }
  scope :upcoming, -> { scheduled.where("date >= ?", Date.current).order(:date) }
  scope :imported, -> { where.not(source: nil) }
  scope :manual, -> { where(source: nil) }

  def track_day?
    kind == "track_day"
  end

  def kind_label
    case kind
    when "track_day" then "Track Day"
    when "sport" then "Спорт"
    else "Другое"
    end
  end
end
