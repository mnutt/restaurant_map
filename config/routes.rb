RestaurantMap::Application.routes.draw do |map|
  map.resources :restaurants, :collection => {:find_restaurant => :any}
 
  # Restful Authentication Rewrites
  match '/logout'                      => 'session#destroy', :as => :logout
  match '/login'                       => 'session#new',     :as => :login
  match '/signup'                      => 'users#new',        :as => :signup
  match '/activate/activation_code'    => 'users#activate',   :as => :activate, :activation_code => nil
  match '/forgot_password'             => 'session#new',     :as => :forgot_password
  match '/change_password/:reset_code' => 'session#new',     :as => :change_password
  
  # Restful Authentication Resources
  resources :users
  resources :passwords
  resource :session
  resources :tags
  
  # Home Page
  root :to => 'restaurants#index'
end
