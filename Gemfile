source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'google-api-client', '~> 0.11', require: 'google/apis/calendar_v3'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'devise'
gem 'figaro'
gem 'icalendar'
gem 'awesome_print'
gem 'json'
gem 'memory_test_fix'
gem 'faker'
gem 'simple_calendar', '~> 2.0'
gem 'git'
gem "octokit", "~> 4.0"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.6'
  gem 'guard-rspec', require: false
  gem 'sqlite3'
  gem 'simplecov', require: false
  gem 'codacy-coverage', :require => false
end


group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
