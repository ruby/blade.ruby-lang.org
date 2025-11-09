source "https://rubygems.org"

ruby file: '.ruby-version'

gem 'nkf'

gem "rails", "~> 8.1.0"

gem "sprockets-rails"

gem 'pg'

gem "puma", ">= 5.0"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem 'tailwindcss-rails'

gem 'action_args'

gem 'active_decorator'


gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'rubocop'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'simplecov'
end

gem 'aws-sdk-s3', '~> 1'
