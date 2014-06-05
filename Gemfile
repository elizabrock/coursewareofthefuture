ruby '2.1.1'
#ruby-gemset=coursewareofthefuture
source 'https://rubygems.org'

# Helps generate the calendar markup on the calendar page
gem 'calendar_helper'
# Authorization gem:  gives us Ability model and can? :edit, item
gem 'cancan'
# Image upload (profile pictures)
gem 'carrierwave'
# Coffeescript
gem 'coffee-rails', '~> 4.0'
# Magic Sauce.  We will get to this.
gem 'decent_exposure'
# Authentication
gem 'devise'
# Foundation / Styling
gem 'foundation-rails'
# Object factories
gem 'fabrication'
# Stores environment variables
gem 'figaro'
# Stores files in the cloud
gem 'fog'
gem 'forem', :github => "radar/forem", :branch => "rails4"
# Enables HAML views
gem 'haml-rails'
# Error reporting
gem 'honeybadger'
# jquery on rails:
gem 'jquery-rails'
# jquery-ui on rails:
gem 'jquery-ui-rails'
# Github API gem:
gem 'octokit'
# OAuth for Github
gem 'omniauth-github'
# Postgres gem
gem 'pg'
# Sent email through Postmark
gem 'postmark-rails'
gem 'rails', '~> 4.1'
# Markdown gem (works with haml's :markdown tag)
gem 'redcarpet'
# Sassy
gem 'sass-rails', '~> 4.0'
# Improves on Rails form_for:
gem 'simple_form'
# Used for rendering materials as slide decks:
gem 'slide-em-up', github: 'elizabrock/slide-em-up', branch: 'master', require: false
# Compresses javacript and css:
gem 'uglifier', '>= 1.3.0'
# rails server that handles multiple connections
gem 'unicorn'
gem 'will_paginate', '3.0.5'

group :production do
  # Makes the heroku logs more informative:
  gem 'rails_12factor'
end

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  # Sent email in development environment will open in your browser:
  gem 'letter_opener'
end

group :test, :development do
  # Generates reasonable looking fake data
  gem 'faker'
  # For debugging:
  gem 'pry-rails'
  # Testing:
  gem 'rspec-rails'
  gem 'rspec'
end

group :test do
  # Sends code coverage information to code climate
  gem 'codeclimate-test-reporter', require: false
  # Cleans up our test database
  gem 'database_cleaner'
  # Email testing helpers
  gem 'email_spec'
  # Enables save_and_open_page from Capybara
  gem 'launchy'
  gem 'minitest'
  # Javascript driver for capybara:
  gem 'poltergeist'
  # Helpers for testing AR, etc.
  gem 'shoulda-matchers'
  # Time travel!!
  gem 'timecop'
  # Mocks external requests and allows you to disable external request
  gem 'webmock'
  # Records external requests
  gem 'vcr'
end
