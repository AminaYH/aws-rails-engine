require_relative "lib/aws_helper_engine/version"

Gem::Specification.new do |spec|
  spec.name        = "aws_helper_engine"
  spec.version     = AwsHelperEngine::VERSION
  spec.authors     = ["mina218"]
  spec.email       = ["amina.yahia@eniso.u-sousse.tn"]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of AwsHelperEngine."
  spec.description = "TODO: Description of AwsHelperEngine."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.5.1"

  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "aws-sdk-ec2"
  spec.add_dependency "aws-sdk-sns"

end
