class Pilot < ApplicationRecord
  has_many :lap_results, dependent: :destroy
end
