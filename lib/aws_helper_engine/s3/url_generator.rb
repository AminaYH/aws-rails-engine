# frozen_string_literal: true
module AwsHelperEngine
  module S3
class UrlGenerator
  def self.generate(bucket_name:, key:, expiration: 3600)
    signer = Aws::S3::Presigner.new
    signer.presigned_url(:get_object, bucket: bucket_name, key: key, expires_in: expiration)
  end
end
end
end
