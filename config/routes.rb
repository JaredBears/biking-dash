Rails.application.routes.draw do

  # get 'pages/home'
  # get 'pages/about'
  # get 'pages/contact'
  # get 'pages/terms'
  # get 'pages/privacy'

  devise_for :users

  resources :reported_cars
  resources :reported_bikes
  resources :reports
  resources :images
  resources :cars
  resources :bikes

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

end
