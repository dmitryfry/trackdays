class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip
    if query.blank?
      render json: { results: [] }
      return
    end

    wildcard = "%#{query}%"
    results = []

    # 1. Tracks
    Track.where("name ILIKE ? OR location ILIKE ?", wildcard, wildcard).limit(5).each do |t|
      results << { type: "Автодром", title: t.name, subtitle: t.location, url: track_path(t) }
    end

    # 2. Events / Track days
    Event.where("title ILIKE ? OR organizer ILIKE ?", wildcard, wildcard).limit(5).each do |e|
      results << { type: "Трек-день / Событие", title: e.title, subtitle: "#{e.date} • #{e.organizer}", url: calendar_path }
    end

    # 3. Championships
    Championship.where("name ILIKE ?", wildcard).limit(5).each do |c|
      results << { type: "Чемпионат", title: c.name, subtitle: c.category, url: championship_path(c.slug) }
    end

    # 4. Pilots
    Pilot.where("name ILIKE ? OR car ILIKE ?", wildcard, wildcard).limit(5).each do |p|
      results << { type: "Пилот", title: p.name, subtitle: "#{p.car} • #{p.pilot_class}", url: pilot_path(p) }
    end

    # 5. Garage Cars
    GarageCar.where("make ILIKE ? OR model ILIKE ?", wildcard, wildcard).limit(5).each do |gc|
      results << { type: "Гараж", title: "#{gc.make} #{gc.model}", subtitle: "#{gc.power_hp} л.с. • #{gc.car_class}", url: garage_car_path(gc) }
    end

    # 6. Marketplace
    MarketListing.active.where("title ILIKE ? OR city ILIKE ?", wildcard, wildcard).limit(5).each do |m|
      results << { type: "Маркетплейс", title: m.title, subtitle: "#{m.formatted_price} • #{m.city}", url: market_item_path(m) }
    end

    # 7. Articles / Blogs
    Article.published.where("title ILIKE ? OR summary ILIKE ?", wildcard, wildcard).limit(5).each do |a|
      results << { type: "Блог / Статья", title: a.title, subtitle: a.category_title, url: blog_post_path(a.slug) }
    end

    respond_to do |format|
      format.json { render json: { results: results } }
      format.html do
        @query = query
        @results = results
      end
    end
  end
end
