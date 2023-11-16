Rails.application.routes.draw do

  devise_for :users

  resources :reported_cars
  resources :reported_bikes
  resources :reports
  resources :cars
  resources :bikes

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
