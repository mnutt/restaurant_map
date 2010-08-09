GrubPoints::Application.routes.draw do
  resources :restaurants, :collection => {:find_restaurant => :any}

  # Restful Authentication Rewrites
  match '/logout'                      => 'user_sessions#destroy', :as => :logout
  match '/login'                       => 'user_sessions#new',     :as => :login
  match '/signup'                      => 'users#new',             :as => :signup
  match '/activate/activation_code'    => 'users#activate',        :as => :activate, :activation_code => nil
  match '/forgot_password'             => 'user_sessions#new',     :as => :forgot_password
  match '/change_password/:reset_code' => 'user_sessions#new',     :as => :change_password
  match '/me'                          => 'users#me',              :as => :my_account

  # Restful Authentication Resources
  resources :users
  resources :passwords
  resource  :user_session
  resources :tags

  resources :foursquare_auth

  # Home Page
  root :to => 'restaurants#index'
end
