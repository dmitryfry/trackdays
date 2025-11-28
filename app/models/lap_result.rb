class LapResult < ApplicationRecord
  belongs_to :event
  belongs_to :pilot
end
