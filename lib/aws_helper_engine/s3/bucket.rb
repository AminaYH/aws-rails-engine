# frozen_string_literal: true
#remebere to create a gem for aws you need to create api interface in this case its s3_ressource(oop api),
# the interface is like a bridges that translate for you your request(from code to real APIrequest)

require 'aws-sdk-s3'
module AwsHelperEngine
  module S3
    class Bucket
      attr_reader :s3_resource, :options, :region

      def initialize(bucket_name, region: 'us-east-1')
        @bucket_name = bucket_name
        @region = region

        @s3_resource = Aws::S3::Resource.new(region: @region)
        @client   = Aws::S3::Client.new(region: @region)

      end

      # Create the bucket with ACL, name, and configuration
      def create_bucket(acl: 'private')
        bucket = @s3_resource.create_bucket(
          bucket: @bucket_name,
          acl: acl,
          create_bucket_configuration: {
            location_constraint: @region
          }
        )
        puts "Created demo bucket named #{bucket.name}."
        bucket
      rescue Aws::Errors::ServiceError => e
        puts "Failed to create bucket: #{e.message}"
      end
      def self.list_buckets
        count=0
        @s3_resource.list_buckets.buckets.each { |i|
          count+1
        }
        return count

      rescue Aws::Errors::ServiceError => e
        puts "Couldn't list buckets. Here's why: #{e.message}"
        false
      end
    def  delete_bucket(bucke_name)
      bucket=@s3_resource.bucket(bucket_name)
      @s3_resource.objects.batch_delete!
      @s3_resource.delete
      # Helper method to check if bucket exists (simulated)
      end

      def put_object(object)
        puts "Putting object '#{object}' in the bucket."
        @s3_client.bucket(@bucket_name).put_object_acl(key: object.key , body: object.body  )
      rescue Aws::Errors::ServiceError => e
        puts "Couldn't list buckets. Here's why: #{e.message}"
        false
      end

  def get_object(key:, response_target:)
    @client.get_object(bucket: @bucket_name, key: key, response_target: response_target)
    puts "Downloaded object '#{key}' to '#{response_target}'."
  rescue Aws::Errors::ServiceError => e
    puts "Failed to get object: #{e.message}"
    nil
  end


    def  delete_all_bucket
      s3_resource.clear!
    end

end
end
end

