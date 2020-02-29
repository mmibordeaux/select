source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Back
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'devise'
gem 'devise-i18n'
gem 'rest-client'
gem 'rubyzip'
gem 'axlsx'#, git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'

# Front
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'nokogiri'
gem 'simple_form'
gem 'bootstrap'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'bootstrap4-kaminari-views'
gem 'jquery-rails'
gem 'chartkick'

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
