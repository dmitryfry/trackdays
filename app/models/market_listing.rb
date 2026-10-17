class MarketListing < ApplicationRecord
  DEAL_TYPES = %w[sale rent want].freeze
  STATUSES = %w[active paused sold].freeze
  PRICE_PERIODS = %w[per_day per_trackday per_stage].freeze

  belongs_to :market_category
  belongs_to :pilot, optional: true
  belongs_to :garage_car, optional: true

  validates :title, :description, :city, :contact_name, presence: true
  validates :deal_type, inclusion: { in: DEAL_TYPES }
  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where(status: "active") }
  scope :sales, -> { where(deal_type: "sale") }
  scope :rents, -> { where(deal_type: "rent") }
  scope :wants, -> { where(deal_type: "want") }
  scope :by_category, ->(category_id) { where(market_category_id: category_id) if category_id.present? }
  scope :by_deal_type, ->(deal_type) { where(deal_type: deal_type) if deal_type.present? }
  scope :by_city, ->(city) { where("city ILIKE ?", "%#{city}%") if city.present? }
  scope :search_query, ->(q) {
    if q.present?
      where("title ILIKE :q OR description ILIKE :q OR city ILIKE :q", q: "%#{q}%")
    end
  }

  def deal_type_label
    case deal_type
    when "sale" then "Продажа"
    when "rent" then "Аренда"
    when "want" then "Ищут"
    else deal_type
    end
  end

  def price_period_label
    case price_period
    when "per_day" then "/ день"
    when "per_trackday" then "/ трек-день"
    when "per_stage" then "/ этап гонки"
    else ""
    end
  end

  def formatted_price
    return "По договоренности" if price.blank? || price.zero?

    formatted = ActionController::Base.helpers.number_to_currency(price, unit: "₽", precision: 0, delimiter: " ")
    "#{formatted} #{price_period_label}".strip
  end
end
