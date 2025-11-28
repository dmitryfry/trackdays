class Event < ApplicationRecord
  belongs_to :track
  has_many :lap_results, dependent: :destroy
end
