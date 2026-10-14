class ChampionshipStage < ApplicationRecord
  belongs_to :championship_season
  belongs_to :track

  validates :stage_number, presence: true
  validates :date, presence: true
  validates :title, presence: true

  scope :ordered, -> { order(:stage_number) }
  scope :upcoming, -> { where(status: "upcoming").order(:date) }
  scope :completed, -> { where(status: "completed").order(:date) }
end
