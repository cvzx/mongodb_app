# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "dry-monads"
gem "dry-struct"
gem "dry-validation"
gem "mongoid"
gem "slim"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-shopify", require: false
end

group :test do
  gem "database_cleaner-mongoid"
  gem "rails-controller-testing"
  gem "rspec-json_expectations"
  gem "simplecov", require: false
  gem "simplecov-console", require: false
end
