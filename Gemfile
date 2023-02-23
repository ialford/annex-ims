def next?
  File.basename(__FILE__) == "Gemfile.next"
end

# frozen_string_literal: true

source 'https://rubygems.org'

group :application do
  if next?
    gem 'rails', '~> 5.2.8'
  else
    gem 'rails', '~> 6.0.6'
  end

  # Use postgresql as the database for Active Record
  gem 'pg', '~> 1.2.3'
  # Use SCSS for stylesheets
  gem 'sassc-rails'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  # Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails'
  # V8 javascript engine for ruby
  gem 'mini_racer'

  # Use jquery as the JavaScript library
  gem 'jquery-rails', '~> 4.3.5'
  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  gem 'turbolinks'
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder', '~> 2.0'
  gem 'bootsnap'

  gem 'next_rails'

  # UI
  gem 'haml-rails'
  gem 'autoprefixer-rails'
  gem 'bootstrap-sass', '~> 3.4.1'
  gem 'bootstrap_progressbar' # for a progress bar
  gem 'bootstrap-datepicker-rails' # nice datepicker for Bootstrap
  gem 'jquery-datatables-rails', '~> 3.4.0'
  gem 'multi-select-rails' # Multiselect for Rails asset pipeline

  # Devise for authentication, CAS for use in ND
  gem 'devise'
  gem 'omniauth-oktaoauth'

  # For consuming the API for items
  gem 'faraday'
  gem 'faraday_middleware'
  gem 'multi_xml'

  # For item search
  gem 'progress_bar' # Because I want to see progress of reindexing
  gem 'sunspot_rails' # , :git => "https://github.com/sunspot/sunspot.git"

  # For paginating results
  gem 'kaminari'

  gem 'sneakers'

  # Bug in rake
  gem 'rake', '~> 13.0'

  # Security updates
  gem 'ffi', '>= 1.9.24'
  gem 'loofah', '~> 2.3.1'
  gem 'bigdecimal'

  # Sentry.io integration
  gem 'sentry-raven'
end

# For cron tasks
gem 'whenever', require: false

# For scheduling tasks
gem 'ice_cube'
gem 'recurring_select', '3.0.1'

group :deployment do
  # Use Capistrano for deployment
  gem 'capistrano', '= 3.11.2'
  gem 'capistrano-maintenance', '~> 1.0'
  gem 'capistrano-rails', '~> 1.1'
end

group :development, :test, :staging do
  # For realistic fake data
  gem 'faker', '~> 1.4'

  gem 'haml_lint', require: false
  gem 'rubocop', '= 0.75.0' # this is the latest version hound supports
  gem 'rubocop-rails'
end

group :development, :test do
  gem 'hesburgh_infrastructure', git: 'https://github.com/ndlib/hesburgh_infrastructure'
  gem 'spring-commands-rspec'

  gem 'coveralls', require: false

  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # We test with Rspec
  gem 'rspec-rails', '~> 3.0'

  # For mocking up objects
  gem 'factory_bot_rails', '~> 4.8.2'

  # For cleaning up the test database
  gem 'database_cleaner', '~> 1.3'

  gem 'eventmachine', '1.2.2'

  # So staging etc can use stand alone Solr
  gem 'sunspot_solr' # , :git => "https://github.com/sunspot/sunspot.git"

  # For serving up ssl
  gem 'thin', '~> 1.8.1'

  gem 'rails-erd'

  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '1.1.0'
end

group :test do
  # For mocking up APIs
  gem 'shoulda-matchers'
  gem 'webmock', '~> 3.7.6'

  gem 'simplecov'

  # rspec matchers for sunspot
  gem 'sunspot_matchers'

  gem 'rails-controller-testing'
end

group :development do
  # Simple generators for layouts
  gem 'rails_layout'

  # Better error page
  gem 'better_errors'
  gem 'binding_of_caller'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  gem 'letter_opener'
end