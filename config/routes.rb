Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Makes the api accessible through the domain api.site.com/resource-name
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  end

end
