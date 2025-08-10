# frozen_string_literal: true
module AwsHelperEngine
  module S3
    class Client
      def initialize(credentials:, region:)
        @client = Aws::S3::Client.new(credentials: credentials, region: region)
      end
    end
  end
end
