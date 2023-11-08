Rails.application.routes.draw do
  resources :reported_cars
  resources :reported_bikes
  resources :reports
  resources :images
  resources :cars
  resources :bikes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
