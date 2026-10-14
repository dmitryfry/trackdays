class Championship < ApplicationRecord
  has_many :championship_seasons, dependent: :destroy
  has_many :championship_stages, through: :championship_seasons

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
