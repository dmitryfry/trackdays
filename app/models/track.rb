class Track < ApplicationRecord
  has_many :events, dependent: :destroy
end
