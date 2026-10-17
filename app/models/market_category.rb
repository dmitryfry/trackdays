class MarketCategory < ApplicationRecord
  has_many :market_listings, dependent: :restrict_with_error

  validates :name, :slug, presence: true, uniqueness: true

  default_scope { order(position: :asc, name: :asc) }
end
