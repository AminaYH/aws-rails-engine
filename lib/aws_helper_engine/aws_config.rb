# frozen_string_literal: true
# this module is for connecting to aws account
require "aws-sdk-core"
module AwsHelperEngine
  module S3
  class AwsConfig
  class << self
    def instance
      @instance ||= new
    end
    attr_reader :access_key_id, :secret_access_key, :http, :options

    def initialize(super_class = nil)
      super
      instance.configure(access_key_id, secret_access_key, http, options)
    end
  end


end
  #this methode to authentificate using IAMroles
  #

end
end
