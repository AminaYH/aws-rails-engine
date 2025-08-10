# frozen_string_literal: true
#remebere to create a gem for aws you need to create api interface in this case its s3_ressource(oop api),
# the interface is like a bridges that translate for you your request(from code to real APIrequest)

require "aws-sdk-s3"
module AwsHelperEngine
  module S3
    class Bucket
      attr_reader :s3_resource, :options, :region

      def initialize(client, ressource, region)
        @region = region
        @s3_resource = ressource
        @s3_client = client
      end

      def create_bucket(bucket_name, acl: "private")
        params = { bucket: bucket_name, acl: acl }

        if @region != "us-east-1"
          params[:create_bucket_configuration] = {
            location_constraint: @region
          }
        end

        @s3_client.create_bucket(params)

        puts "Created demo bucket named #{bucket_name}."
        @s3_resource.bucket(bucket_name)
      rescue Aws::Errors::ServiceError => e
        "Failed to create bucket: #{e.message}"
      end

      def list_buckets
        count = 0
        @s3_client.list_buckets.buckets.each { |i| count + 1 }
        return count
      rescue Aws::Errors::ServiceError => e
        puts "Couldn't list buckets. Here's why: #{e.message}"
        false
      end
      def delete_bucket(bucket_name)
        bucket = @s3_resource.bucket(bucket_name)
        bucket.objects.each(&:delete)
        bucket.delete
      rescue Aws::Errors::ServiceError => e
        puts "Failed to delete bucket: #{e.message}"
        nil
      end

      def put_object(bucket_name, object)
        puts "Putting object '#{object}' in the bucket."
        @s3_resource.bucket(bucket_name).put_object(
          key: object.key,
          body: object.body
        )
        return "Uploaded successfully."
      rescue Aws::Errors::ServiceError => e
        puts "Couldn't list buckets. Here's why: #{e.message}"
        false
      end

      def get_object(bucket_name:, key:, response_target:)
        @s3_client.get_object(
          bucket: bucket_name,
          key: key,
          response_target: response_target
        )
        puts "Downloaded object '#{key}' to '#{response_target}'."
      rescue Aws::Errors::ServiceError => e
        puts "Failed to get object: #{e.message}"
        nil
      end

      def delete_all_bucket
        @s3_resource.clear!
      end
      def bucket_exists?(bucket_name)
        @s3_client.head_bucket(bucket: bucket_name)
        true
      rescue Aws::S3::Errors::NotFound
        false
      rescue Aws::Errors::ServiceError => e
        puts "Error checking bucket: #{e.message}"
        false
      end
      def list_objects(bucket_name)
        bucket = @s3_resource.bucket(bucket_name)
        bucket.objects.each { |obj| puts obj.key }
      rescue Aws::Errors::ServiceError => e
        puts "Failed to list objects: #{e.message}"
        []
      end
      def delete_object(bucket_name, key)
        bucket = @s3_resource.bucket(bucket_name)
        bucket.object(key).delete
        puts "Deleted object '#{key}' from bucket '#{bucket_name}'."
        true
      rescue Aws::Errors::ServiceError => e
        puts "Failed to delete object: #{e.message}"
        false
      end
      def object_exists?(bucket_name, key)
        @s3_client.head_object(bucket: bucket_name, key: key)
        true
      rescue Aws::S3::Errors::NotFound
        false
      rescue Aws::Errors::ServiceError => e
        puts "Error checking object: #{e.message}"
        false
      end
    end
  end
end
