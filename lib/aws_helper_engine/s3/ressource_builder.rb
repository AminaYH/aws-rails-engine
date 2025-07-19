# frozen_string_literal: true
module AwsHelperEngine
  module S3
    class RessourceBuilder
      def self.initialize(credentials:, region:)
        Aws::S3::Resource.new(credentials: credentials, region: region)
      end
    end
  end
end
