require "aws-sdk-ec2"
module AwsHelperEngine
  module EC2
    class Client
      
      def initialize(region: "us-east-1")
        @client = Aws::EC2::Client.new(region: region)
      end
      attr_reader :client

    end
  end
end
