source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# config ENV by dotenv
gem 'dotenv-rails'

# pry and ap
gem 'pry'
gem 'pry-rails'
gem 'awesome_print'

# http client
gem 'faraday', '~> 0.15.2'

# faster json
gem 'oj', '~> 3.6', '>= 3.6.2'

# json serializer for api
gem 'active_model_serializers', '~> 0.10.7'

gem 'daemons', '~> 1.2', '>= 1.2.6'

# support for Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', require: 'rack/cors'

# ransack for SQL search
gem 'ransack', '~> 1.8', '>= 1.8.8'

# paginate
gem 'kaminari'

gem 'google-protobuf', '~> 3.6'

gem 'ciri-crypto', '0.1.1'

gem 'ethereum.rb'

# Deployment
gem 'mina', require: false
gem 'mina-puma', require: false
gem 'mina-multistage', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', '~> 3.7'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'yard', '~> 0.9.14'
  gem 'yard-activesupport-concern'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'

  # mock http request
  gem 'webmock', '~> 3.4', '>= 3.4.2'
  gem 'codecov', :require => false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
