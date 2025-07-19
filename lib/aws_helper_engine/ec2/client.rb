require "aws-sdk-ec2"
module AwsHelperEngine
  module Ec2
    class Client
      def initialize(region: "us-east-1")
        @client = Aws::EC2::Client.new(region: region)
      end
    end
  end
end
