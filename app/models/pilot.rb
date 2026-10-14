class Pilot < ApplicationRecord
  belongs_to :team, optional: true
  has_many :lap_results, dependent: :destroy
  has_many :championship_standings, dependent: :destroy
  has_many :gps_dyno_runs, dependent: :nullify

  validates :name, presence: true

  scope :top_ranked, -> { order(points: :desc, wins_count: :desc, podiums_count: :desc) }
end
