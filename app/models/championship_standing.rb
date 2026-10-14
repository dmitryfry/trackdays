class ChampionshipStanding < ApplicationRecord
  belongs_to :championship_season
  belongs_to :pilot
  belongs_to :team, optional: true

  validates :racing_class, presence: true
  validates :position, presence: true

  scope :ordered, -> { order(:position) }
end
