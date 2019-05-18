require 'api_version_constraint'

Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }
  # Makes the api accessible through the domain -> api.site.com/resource-name
  
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # Extra configuration about the API should be passed on the headers instead of URL
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new( version: 1 ) do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end
    # The default version should come last in the routes file, otherwise it will always be called 
    # even if the consumer try to access other version
    namespace :v2, path: '/', constraints: ApiVersionConstraint.new( version: 2, default: true ) do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end