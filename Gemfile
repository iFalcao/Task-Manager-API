source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# A partir dessa versão houve uma correção de uma vulnerabilidade crítica
gem 'devise', ">= 4.6.0"
gem "ffi", ">= 1.9.24"
gem "activejob", ">= 5.1.6.1"
gem "actionview", ">= 5.1.6.2"
gem 'active_model_serializers', '~> 0.10.0'
gem 'mask_man', '~> 0.2.0'
gem 'ransack'
gem 'omniauth'
gem 'devise_token_auth'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # RSpec for Rails-3+
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'
end

group :test do
  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing. 
  gem 'database_cleaner'
  # Collection of testing matchers extracted from Shoulda 
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
