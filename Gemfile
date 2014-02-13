source 'https://rubygems.org'

group :default do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.0.2'

  # Use postgresql as the database for Active Record
  gem 'pg'

  # Use Haml for templates
  gem 'haml'
  gem 'json2-rails'
  gem 'spine-rails'
  gem 'eco'

  # Performance
  gem 'delayed_job_active_record'

  # Active Admin related stuff
  gem 'activeadmin', github: 'gregbell/active_admin'
  gem 'draper', '>= 1.0.0'
  gem 'omniauth-osm'

  # Internationalisation
  gem 'i18n'
  gem 'rails-i18n'
  gem 'devise-i18n'

  # Geo Stuff
  gem 'geocoder', github: 'alexreisner/geocoder'
  gem 'rgeo'
  gem 'country_select'
  gem 'nominatim'
  gem 'leaflet-rails'

  # API and data fetching
  gem 'httparty'
  gem 'rosemary'

  # Use Iconic webfonts
  gem 'font-awesome-rails'

end

group :asssets do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'

  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'

  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  # Use jquery as the JavaScript library
  gem 'jquery-rails'

  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  # gem 'turbolinks'

  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder'

end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

group :production do
  # Use unicorn as the app server
  gem 'unicorn'
end

# Use Capistrano for deployment
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano',       '~> 3.1.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end

group :development, :test do
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-annotate'
  gem 'guard-pow',     require: false
  gem 'guard-bundler', require: false
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'coveralls',     require: false
end

group :test do
  gem 'webmock'
  gem 'vcr'
end
# Use debugger
# gem 'debugger', group: [:development, :test]
