require "aws-sdk-cloudwatch"
require "aws-sdk-sns"
module AwsHelperEngine
  module CloudWatch
    class Client
      def initialize(sns_client, region)
        @cloudwatch = Aws::CloudWatch::Client.new(region: region)
        @sns_client = sns_client
      end
    end
  end
end
