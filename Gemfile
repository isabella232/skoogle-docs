source "https://rubygems.org"
gemspec

gem "yard"

group :development do
  gem "pry"
end

group :test do
  gem "coveralls", require: false
  gem "simplecov", require: false
  gem "codeclimate-test-reporter", require: false
end

group :development, :test do
  gem "guard"
  gem "guard-rspec", require: false
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "guard-rubocop", require: false
  gem "guard-yardstick", require: false
end
