source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

gem 'awesome_print'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'faker'
gem 'figaro'
gem 'git'
gem 'google-api-client', '~> 0.11', require: 'google/apis/calendar_v3'
gem 'icalendar'
gem 'jbuilder', '~> 2.5'
gem 'json'
gem 'memory_test_fix'
gem 'octokit', '~> 4.0'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'simple_calendar', '~> 2.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'crono'
gem 'webmock'
gem 'redcarpet'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'guard-rspec', require: false
  gem 'rspec-rails', '~> 3.6'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'sqlite3'
  gem 'rails-controller-testing'
  gem 'vcr'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
