class ChampionshipSeason < ApplicationRecord
  belongs_to :championship
  has_many :championship_stages, dependent: :destroy
  has_many :championship_standings, dependent: :destroy

  validates :year, presence: true
  validates :title, presence: true

  scope :latest, -> { order(year: :desc) }
end
