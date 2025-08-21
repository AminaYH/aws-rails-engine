source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in aws_helper_engine.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
gem "aws-sdk-s3"
gem "aws-sdk-dynamodb"
gem "aws-sdk-ec2"
gem "aws-sdk-iam"
group :development, :test do
  gem "rspec-rails"
  gem "ruby-lsp"
  gem "dotenv-rails"
end

gem "syntax_tree", "~> 6.3"

gem "rspec", "~> 3.13"

gem "gem", "~> 0.0.1.alpha"
gem "aws-sdk-cloudwatch", "~> 1.115"

gem "gems", "~> 1.3"
gem "aws-sdk-cloudwatchlogs", "~> 1.116"

gem "aws-sdk-lambda", "~> 1.151"

gem "rubyzip", "~> 3.0"
