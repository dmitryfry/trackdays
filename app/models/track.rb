class Track < ApplicationRecord
  has_many :events, dependent: :destroy

  SOURCE_KEYS = %w[igora mrv smolensk nring kazan].freeze

  validates :source_key, uniqueness: true, allow_nil: true, inclusion: { in: SOURCE_KEYS, allow_nil: true }
end
