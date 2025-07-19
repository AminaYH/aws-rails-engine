# frozen_string_literal: true
module AwsHelperEngine
  module S3
    class Client
      def initialize(credentials:, region:)
        @client = Aws::S3::Client.new(credentials: credentials, region: region)
      end
      def put_object(bucket_name:, key:, body:, acl: "private")
        @client.put_object(bucket: bucket_name, key: key, body: body, acl: acl)
      end

      def get_object(bucket_name:, key:)
        @client.get_object(bucket: bucket_name, key: key)
      end

      def delete_object(bucket_name:, key:)
        @client.delete_object(bucket: bucket_name, key: key)
      end
    end
  end
end
