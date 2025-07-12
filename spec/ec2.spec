# frozen_string_literal: true
require 'aws_helper_engine/ec2'

RSpec.describe  AwsHelperEngine::EC2 do
  describe "ec2 test" do
    it "client connection succeds" do
      client=describe_class.initialize(region: 'us-east-1')
      expect(client).to be_an_instance_of(Aws::EC2::Client)
    end
  end
end
