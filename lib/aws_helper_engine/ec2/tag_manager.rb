# lib/aws_helper_engine/ec2/tag_manager.rb
require "aws-sdk-ec2"

module AwsHelperEngine
  module EC2
    class TagManager
      def initialize(resource_id, client, key = nil, value = nil, options = {})
        @resource_id = resource_id
        @key = key
        @value = value
        @region = options[:region] || "us-west-2"
        @client = options[:client] || client
      end

      def create
        raise "Key and value must be provided" unless @key && @value

        @client.create_tags(
          resources: [@resource_id],
          tags: [{ key: @key, value: @value }]
        )
      end

      def delete
        raise "Key must be provided" unless @key

        @client.delete_tags(resources: [@resource_id], tags: [{ key: @key }])
      end

      def list
        response =
          @client.describe_tags(
            filters: [{ name: "resource-id", values: [@resource_id] }]
          )

        response.tags.map { |tag| { key: tag.key, value: tag.value } }
      end
    end
  end
end
