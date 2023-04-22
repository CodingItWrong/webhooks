source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(".ruby-version").chomp)

gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "puma", "~> 5.0"

group :development, :test do
  gem "debug"
  gem "standard"
end
