# frozen_string_literal: true
# frozen_string_literal: true
require 'aws-sdk-ec2'
require 'logger'

module AwsHelperEngine
  module Ec2
class KeyPair
  
  def initialize(name,  options = {})
    @name=name
    @key_type = options[:key_type] || 'rsa'
    @key_format=options[:key_format] || 'pem'
    @tags = options[:tags] || [] @key_format = options[:key_format] || 'pem'
    @client = Aws::EC2::Client.new(region: options[:region] || 'us-east-1')
    @dry_run=options[:dry_run] || false
  
  end
 def create
  @response= @client.create_key_pair(
    key_name: @name,
    key_type: @key_type,
    key_format: @key_format,
    dry_run: dry_run,
    tag_specifications: @tags.empty? ? [] : [{
      resource_type: 'key-pair',
      tags: @tags
    }]
  )
  @response
end
  def delete
    @client.delete_key_pair({
    key_name: @name,
    key_pair_id: get_key_pair_id
    ,dry_run: @dry_run
  }
      )
  end
  def get_key_pair_id
     @response&.key_pair_id
  end
  
end
end
