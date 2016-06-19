Rails.application.routes.draw do
  devise_for :users

  resources :links, :except => [:update]

  root :to => 'links#new'

end
