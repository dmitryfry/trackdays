class MarketController < ApplicationController
  before_action :set_categories

  def index
    @categories = MarketCategory.all
    @listings = MarketListing.active.order(created_at: :desc)

    @listings = @listings.by_category(params[:category_id]) if params[:category_id].present?
    @listings = @listings.by_deal_type(params[:deal_type]) if params[:deal_type].present?
    @listings = @listings.by_city(params[:city]) if params[:city].present?
    @listings = @listings.search_query(params[:q]) if params[:q].present?

    @deal_counts = {
      all: MarketListing.active.count,
      sale: MarketListing.active.sales.count,
      rent: MarketListing.active.rents.count,
      want: MarketListing.active.wants.count
    }
  end

  def show
    @listing = MarketListing.find(params[:id])
    @related_listings = MarketListing.active
                                     .where.not(id: @listing.id)
                                     .where(market_category_id: @listing.market_category_id)
                                     .limit(3)
  end

  def new
    @listing = MarketListing.new
    @garage_cars = GarageCar.all
    @pilots = Pilot.all
  end

  def create
    @listing = MarketListing.new(listing_params)
    if @listing.save
      redirect_to market_listing_path(@listing), notice: "Объявление успешно опубликовано на маркетплейсе!"
    else
      @garage_cars = GarageCar.all
      @pilots = Pilot.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_categories
    @categories = MarketCategory.all
  end

  def listing_params
    params.require(:market_listing).permit(
      :market_category_id,
      :pilot_id,
      :garage_car_id,
      :deal_type,
      :title,
      :description,
      :price,
      :currency,
      :price_period,
      :city,
      :contact_name,
      :contact_phone,
      :contact_telegram,
      :image_url
    )
  end
end
