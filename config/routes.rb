Rails.application.routes.draw do
  root "home#index"
  
  get 'calendar', to: 'calendar#index'
  get 'tracks', to: 'tracks#index'
  get 'results', to: 'results#index'
  get 'wiki', to: 'wiki#index'
  get 'admin', to: 'admin#index'
  
  # API routes for Wiki (AI service)
  post 'wiki/ask', to: 'wiki#ask'
end
