Rails.application.routes.draw do

  devise_for :users

  resources :links, :except => [:update, :show, :edit] do
    resources :charts, :only => [:index]
    get 'charts/:chart', :controller => :charts, :action => :show, :as => 'chart', :only => [:html, :json]
  end
  get ':slug', :controller => :links, :action => :process_slug

  root :to => 'links#new'

end
