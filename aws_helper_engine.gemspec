require_relative "lib/aws_helper_engine/version"

Gem::Specification.new do |spec|
  spec.name        = "aws_helper_engine"
  spec.version     = AwsHelperEngine::VERSION
  spec.authors     = ["mina218"]
  spec.email       = ["aminayahia219@gmail.com"]
  spec.homepage    = "https://github.com/mina218/aws_helper_engine"
  spec.summary     = "Helper engine for interacting with AWS services in Rails apps"
  spec.description = "AWSHelperEngine is a Rails engine that simplifies interactions with AWS S3, EC2, and SNS by providing an easy-to-use interface."
  spec.license     = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mina218/aws_helper_engine"
  spec.metadata["changelog_uri"] = "https://github.com/mina218/aws_helper_engine/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.5.1"
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "aws-sdk-ec2"
  spec.add_dependency "aws-sdk-sns"
  spec.add_dependency "aws-sdk-core"
end

