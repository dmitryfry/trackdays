class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :asc) }, dependent: :destroy

  validates :title, :content, :category, presence: true
  validates :category, inclusion: { in: %w[report guide setup news review] }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  scope :published, -> { where(published: true).order(created_at: :desc) }
  scope :by_category, ->(cat) { where(category: cat) if cat.present? }

  def category_title
    case category
    when "report" then "Отчет с гонки"
    when "guide" then "Гайд / Тюнинг"
    when "setup" then "Настройка подвески"
    when "news" then "Новости"
    else "Статья"
    end
  end

  private

  def generate_slug
    return if slug.present?
    base = title.to_s.parameterize
    base = "article-#{SecureRandom.hex(4)}" if base.blank?
    self.slug = "#{base}-#{SecureRandom.hex(3)}"
  end
end
