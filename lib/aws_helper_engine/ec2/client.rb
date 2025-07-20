require "aws-sdk-ec2"
module AwsHelperEngine
  module EC2
    class Client
      def initialize(region:, **options)
        @client = Aws::EC2::Client.new(region: region, **options)
      end
      attr_reader :client
    end
  end
end
