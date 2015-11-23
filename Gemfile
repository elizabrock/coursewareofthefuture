ruby '2.2.3'
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
# For CSS3 sass mixins:
gem "compass-rails", github: "Compass/compass-rails" # waiting for the next release
# Lets rails use d3.js visualization
gem 'd3-rails'
# Magic Sauce.  We will get to this.
gem 'decent_exposure'
# Authentication
gem 'devise'
# Foundation / Styling
gem 'foundation-rails', '~> 5.2'
# Object factories
gem 'fabrication'
# Stores environment variables
gem 'figaro'
# Stores files in the cloud
gem 'fog'
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
gem 'sass-rails'
# Improves on Rails form_for:
gem 'simple_form'
# Used for rendering materials as slide decks:
gem 'slide-em-up', github: 'elizabrock/slide-em-up', branch: 'master', require: false
# Compresses javacript and css:
gem 'uglifier', '>= 1.3.0'
# rails server that handles multiple connections
gem 'unicorn'

group :production do
  # Makes the heroku logs more informative:
  gem 'rails_12factor'
end

group :development do
  # Sent email in development environment will open in your browser:
  gem 'letter_opener'
  # Creates viewable ERD
  gem 'rails-erd'
end

group :test, :development do
  # Generates reasonable looking fake data
  gem 'faker'
  # For debugging:
  gem 'pry-rails'
  # Testing:
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec', '~> 3.0'
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
