require 'api_version_constraint'

Rails.application.routes.draw do

  # Makes the api accessible through the domain -> api.site.com/resource-name
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # Extra configuration about the API should be passed on the headers instead of URL
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new( version: 1, default: true ) do
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end