source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in aws_helper_engine.gemspec.
gemspec

gem "puma"

gem "sqlite3"

gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
gem 'aws-sdk-s3'
gem 'aws-sdk-dynamodb'
gem 'aws-sdk-ec2'
group :development, :test do
  gem 'rspec-rails'
  gem 'ruby-lsp'
  gem "dotenv-rails"
  gem  "rufo"

end

gem "syntax_tree", "~> 6.3"
