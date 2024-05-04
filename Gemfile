source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Infrastructure
gem 'puma'
gem 'pg'

# Back
gem 'rails', '~> 6.0'
gem 'devise'
gem 'devise-i18n'
gem 'devise-bootstrap-views'
gem 'rest-client'
gem 'rubyzip'
gem 'caxlsx'#, git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'caxlsx_rails'
gem 'breadcrumbs_on_rails'
gem 'nokogiri'
gem 'base64'
gem 'bigdecimal'

# Front
gem 'sassc-rails'
gem 'uglifier'
gem 'simple_form'
gem 'bootstrap', '~> 4'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'bootstrap4-kaminari-views'
gem 'jquery-rails'
gem 'chartkick'
gem 'font-awesome-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'annotate'
  gem 'figaro'
  gem 'http_logger'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end
