source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.0.6'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'mongoid', '~> 7.0.5'

group :test do
  gem 'database_cleaner-mongoid'
  gem "factory_girl_rails" , '~> 1.7.0'
  gem 'mongoid-rspec'
  # gem "test-unit"
  # gem "mocha", :require => false
  # gem 'capybara', '~> 2.18'
  # gem "launchy"
  # gem "autotest"
  # gem "autotest-rails-pure"
  # gem "autotest-notification"
  gem 'webmock'
  # gem 'ruby-prof'
  # # Easy installation and use of web drivers to run system tests with browsers
  # gem 'webdrivers'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'

  gem 'rspec-rails', '~> 4.0.0.rc1'
  gem 'rails-controller-testing'
  # Call 'bye_bug.rb' anywhere in the code to stop execution and get a debugger console
  gem 'shoulda', '~> 3.5.0'
  gem 'shoulda-matchers'
  gem 'shoulda-context'

  gem 'rack_session_access'
  gem 'timecop'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
  gem 'rubocop-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'activeadmin-mongoid', '1.0.0'
gem 'activeadmin_blaze_theme'
gem 'ransack-mongoid', github: 'activerecord-hackery/ransack-mongoid'
gem 'devise'
gem 'draper'
gem 'faraday'
gem 'haml'

