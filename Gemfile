source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(".ruby-version").chomp)

gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "puma", "~> 5.0"

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
end

group :production do
  gem "rack-attack"
end
