source 'https://rubygems.org'


gem 'rails', '4.2.4'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'haml'
gem 'devise'
gem 'simple_form'
gem 'hstore_accessor'
gem "jsonb_accessor"
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem "simple_token_authentication", "~> 1.0"
gem 'mandrill_mailer'
gem 'jbuilder', '~> 2.0'
gem 'thor'
gem 'ransack'

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'shoulda'
  gem "database_cleaner"
  gem "factory_girl"
end

group :development do
  gem 'spring'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
end
group :production, :staging do
  gem "unicorn-rails"
  gem 'unicorn'
end
