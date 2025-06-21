module AwsHelperEngine
module dynamodb
  class connection
    def initialize(region: 'us-east-1')
      @client = Aws::DynamoDB::Client.new(region)
    end
  end
end
end