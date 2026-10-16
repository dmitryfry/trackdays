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

  # API routes for Wiki (AI service)
  post 'wiki/ask', to: 'wiki#ask'
end
