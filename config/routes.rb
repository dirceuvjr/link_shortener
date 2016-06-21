Rails.application.routes.draw do

  devise_for :users
  resources :links, :except => [:update]

  get ':slug', :controller => :links, :action => :process_slug

  root :to => 'links#new'

end
