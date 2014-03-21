# A sample Gemfile
source "https://rubygems.org"

ruby '2.0.0'
gem 'sinatra'
gem 'rack'

gem 'contentful'
gem 'haml'
gem 'redcarpet'
gem 'redis'

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rb-fsevent'
  gem 'awesome_print'
  gem 'pry-plus'
  gem 'dotenv'
end

group :test do
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rack-test'
end

group :production do
  gem 'puma'
end
