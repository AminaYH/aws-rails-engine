# frozen_string_literal: true

# This module is for connecting to an AWS account
require "aws-sdk-core"

module AwsHelperEngine
  module S3
    class AwsConfig
      attr_reader :access_key_id, :secret_access_key, :http, :options

      def initialize(
        access_key_id: nil,
        secret_access_key: nil,
        http: nil,
        options: {}
      )
        @access_key_id = access_key_id
        @secret_access_key = secret_access_key
        @http = http
        @options = options
      end

      class << self
        def instance
          @instance ||= new
        end
      end

      # This method will configure the credentials manually
      def configure(access_key_id:, secret_access_key:, http: nil, options: {})
        @access_key_id = access_key_id
        @secret_access_key = secret_access_key
        @http = http
        @options = options
      end

      # This method can authenticate using IAM roles (example, not complete)
      def authenticate_with_iam_role
        # Here you can load credentials from environment or instance profile
      end
    end
  end
end
