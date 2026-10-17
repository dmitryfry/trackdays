Rails.application.routes.draw do
  root "home#index"
  
  get 'calendar', to: 'calendar#index', as: :calendar
  get 'tracks', to: 'tracks#index', as: :tracks
  get 'results', to: 'results#index', as: :results
  get 'wiki', to: 'wiki#index', as: :wiki
  get 'admin', to: 'admin#index', as: :admin
  
  # Live Timing & Telemetry
  get 'timing', to: 'timing#index', as: :timing
  get 'timing/:id', to: 'timing#show', as: :timing_session
  get 'timing/:id/live_feed', to: 'timing#live_feed'

  # GPSDyno
  get 'power', to: 'gps_dyno#index', as: :power
  get 'power/new', to: 'gps_dyno#new', as: :new_gps_dyno
  post 'power', to: 'gps_dyno#create'
  get 'power/:id', to: 'gps_dyno#show', as: :gps_dyno_run

  # Championships & Series
  get 'championships', to: 'championships#index', as: :championships
  get 'championships/:slug', to: 'championships#show', as: :championship

  # Pilots & Teams
  get 'pilots', to: 'pilots#index', as: :pilots
  get 'pilots/:id', to: 'pilots#show', as: :pilot
  get 'teams', to: 'teams#index', as: :teams
  get 'teams/:slug', to: 'teams#show', as: :team

  # Garage & Car Logbooks
  get 'garage', to: 'garage#index', as: :garage
  get 'garage/feed', to: 'garage#feed', as: :garage_feed
  get 'garage/new', to: 'garage#new', as: :new_garage_car
  post 'garage', to: 'garage#create'
  get 'garage/:id', to: 'garage#show', as: :garage_car
  post 'garage/:id/logbook', to: 'garage#create_logbook_entry', as: :create_logbook_entry

  # Marketplace
  get 'market', to: 'market#index', as: :market
  get 'market/new', to: 'market#new', as: :new_market_listing
  post 'market', to: 'market#create'
  get 'market/:id', to: 'market#show', as: :market_listing

  # Simracing & AC Integration
  get 'virtual/servers', to: 'simracing#servers', as: :sim_servers
  get 'virtual/leaderboard', to: 'simracing#leaderboard', as: :sim_leaderboard
  get 'virtual/mods', to: 'simracing#mods', as: :sim_mods

  # Sim Club Booking
  get 'booking', to: 'booking#index', as: :booking
  post 'booking', to: 'booking#create'

  # Auth & User Profile
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  get 'register', to: 'users#new', as: :register
  post 'users', to: 'users#create'
  get 'profile', to: 'users#show', as: :profile

  # Community Blogs & Articles
  get 'blogs', to: 'blogs#index', as: :blogs
  get 'blogs/new', to: 'blogs#new', as: :new_blog_post
  post 'blogs', to: 'blogs#create'
  get 'blogs/:slug', to: 'blogs#show', as: :blog_post
  post 'blogs/:slug/comments', to: 'blogs#create_comment', as: :blog_post_comments

  # News & Media
  get 'news', to: 'media#news', as: :news
  get 'videos', to: 'media#videos', as: :videos

  # Global Omnisearch (Cmd+K)
  get 'search', to: 'search#index', as: :search

  # API routes for Wiki (AI service)
  post 'wiki/ask', to: 'wiki#ask'
end
