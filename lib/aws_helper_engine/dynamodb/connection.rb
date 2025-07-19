module AwsHelperEngine
  module Dynamodb
    class Connection
      def initialize(region: "us-east-1")
        @client = Aws::DynamoDB::Client.new(region)
      end
    end
  end
end
