Randomapp::Application.routes.draw do
  resources :nodes


  resources :links


  resources :events


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end