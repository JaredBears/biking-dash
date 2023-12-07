Rails.application.routes.draw do

  # get 'pages/home'
  # get 'pages/about'
  # get 'pages/contact'
  get 'pages/terms', as: 'terms'
  get 'pages/privacy', as: 'privacy'

  # devise_for :users

  # resources :reported_cars
  # resources :reported_bikes
  # resources :reports
  # resources :cars
  # resources :bikes
  # resources :blu_iterators

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  post "/pathfinder/findRoute", to: "pathfinder#findRoute"
  get "/pathfinder", to: "pathfinder#show"

end
