require "aws-sdk-s3"
require "securerandom"

module AwsHelperEngine
  module S3
    class ObjectManager
      def initialize(client, resource, region = "us-east-1")
        @region = region
        @s3_resource = resource
        @s3_client = client
      end

      def upload_file(bucket_name, file_path, key = nil)
        original_filename = File.basename(file_path)
        key ||= "#{SecureRandom.uuid}_#{original_filename}"
        bucket = @s3_resource.bucket(bucket_name)
        bucket.object(key).upload_file(file_path)
        puts "Uploaded '#{file_path}' to '#{bucket_name}/#{key}'"
        key
      rescue Aws::Errors::ServiceError => e
        puts "Upload failed: #{e.message}"
      end

      def download_file(bucket_name, key, destination_path)
        @s3_client.get_object(
          response_target: destination_path,
          bucket: bucket_name,
          key: key
        )
        puts "Downloaded '#{key}' to '#{destination_path}'"
        destination_path # or key
      rescue Aws::Errors::ServiceError => e
        puts "Download failed: #{e.message}"
        raise # so tests fail instead of silently returning nil
      end

      def copy_object(source_bucket, source_key, dest_bucket, dest_key)
        @s3_client.copy_object(
          copy_source: "#{source_bucket}/#{source_key}",
          bucket: dest_bucket,
          key: dest_key
        )
        puts "Copied '#{source_bucket}/#{source_key}' to '#{dest_bucket}/#{dest_key}'"
      rescue Aws::Errors::ServiceError => e
        puts "Copy failed: #{e.message}"
      end

      def generate_presigned_url(bucket_name, key, expires_in: 3600)
        signer = Aws::S3::Presigner.new(client: @s3_client)
        url =
          signer.presigned_url(
            :get_object,
            bucket: bucket_name,
            key: key,
            expires_in: expires_in
          )
        puts "Generated presigned URL (expires in #{expires_in}s):"
        puts url
        url
      rescue Aws::Errors::ServiceError => e
        puts "Failed to generate URL: #{e.message}"
        nil
      end
    end
  end
end
