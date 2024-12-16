source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(".ruby-version").chomp)

gem "rails", "~> 8.0.1"
gem "puma", "~> 6.5"
gem "httparty"

group :development do
  gem "dotenv-rails"
end

group :development, :test do
  gem "debug"
  gem "rspec-rails"
  gem "standard"
end

group :test do
  gem "rspec_junit_formatter"
  gem "vcr"
  gem "webmock"
end

group :production do
  gem "rack-attack"
end
