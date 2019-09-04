source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.2.2.1'
gem 'nokogiri', '~> 1.10', '>= 1.10.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# config ENV by dotenv
gem 'dotenv-rails'

# pry and ap
# pry 0.12.0 will cause some warning with pry-rails (deprecated), so upgrade this later.
gem 'pry', '0.11.3'
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
gem 'ransack', '~> 2.0', '>= 2.0.1'

# paginate
gem 'kaminari', '~> 1.1', '>= 1.1.1'

gem 'google-protobuf', '~> 3.7'

gem 'ciri-crypto', '0.1.1'

gem 'ethereum.rb', '~> 2.2'

gem 'health_check', '~> 3.0'

# CITA sdk
gem 'cita-sdk-ruby', '~> 0.24.0', require: 'cita'
gem 'web3-eth', '0.2.18'

# Redis
gem 'hiredis', '~> 0.6.1'
gem 'redis', '~> 4.0', '>= 4.0.3'
gem 'redis-namespace', '~> 1.6'
gem 'redis-objects', '~> 1.4', '>= 1.4.3'

# Sidekiq
gem 'sidekiq', '~> 5.2', '>= 5.2.3'
gem 'sidekiq-bulk', '~> 0.2.0'

# union primary key
gem 'composite_primary_keys', '~> 11.1'

# Deployment
gem 'mina', require: false
gem 'mina-puma', require: false
gem 'mina-multistage', require: false
gem 'mina-sidekiq', '~> 1.0', '>= 1.0.3', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', '~> 3.7'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'yard', '>= 0.9.20'
  gem 'yard-activesupport-concern'

  # Ruby static code analyzer and code formatter
  gem "rubocop", "~> 0.59", require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # mock http request
  gem 'webmock', '~> 3.4', '>= 3.4.2'
  gem 'codecov', :require => false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
