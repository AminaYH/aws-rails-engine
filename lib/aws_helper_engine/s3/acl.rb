# frozen_string_literal: true

require "aws-sdk-s3"
module AwsHelperEngine
  module S3
    class Acl
      def initialize(bucket_name, object_key)
        @s3_client = Aws::S3::Client.new(region: @region)
        @s3_ressource = Aws::S3::Resource.new(region: @region)
      end
      def get_access_bucket(bucket_name)
        grant = @s3_ressource.bucket(bucket_name).acl.grants
        grantee = grant.grantee
        puts "#{grantee.display_name || grantee.uri || grantee.id}"
        puts "#{grant.owner}"
      end
      def get_access_object(object_name)
        grant = @s3_client.get_object()
        grantee = grant.grantee
        puts "#{grantee.display_name || grantee.uri || grantee.id}"
        puts "#{grant.owner}"
      end

      private

      def find_bucket(object_name)
      end
    end
  end
end
