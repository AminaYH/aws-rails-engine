# frozen_string_literal: true
require "aws-sdk-s3"
module AwsHelperEngine
  module S3
    class Credentials
      def initialize(access_key_id, secret_access_key, session_token = nil)
        @access_key_id = access_key_id
        @secret_access_key = secret_access_key
        @session_token = session_token
      end
      def credentials
        if @session_token
          Aws::Credentials.new(
            @access_key_id,
            @secret_access_key,
            @session_token
          )
        else
          Aws::Credentials.new(@access_key_id, @secret_access_key)
        end
      end
    end
  end
end
