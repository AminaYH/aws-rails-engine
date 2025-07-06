# frozen_string_literal: true
# frozen_string_literal: true
require 'aws-sdk-ec2'
require 'logger'
require 'openssl'
module AwsHelperEngine
  module Ec2
class KeyPair
  
  def initialize(name,client,  options = {})
    @name=name
    @key_type = options[:key_type] || 'rsa'
    @key_format=options[:key_format] || 'pem'
    @tags = options[:tags] || []
    @key_format = options[:key_format] || 'pem'
    @client=client
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
  save_private_key(@name,@response)
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
  def fingerprint
  resp=@client.describe_key_pair(@name)
  resp&.key_fingerprint
end

  def import(name)
    resp = client.import_key_pair({
      tag_specifications: @tag_specifications,
      dry_run: @dry_run,
      key_name: @name,
      public_key_material: extract_public_key(name).
  end
  def save_private_key(name, response)
    File.write("#{name.pem}",response.key_material)
    File.chmod(0600, "#{name}.pem") 
  end
  def extract_public_key(name)
    rsa_key= OpenSSL::PKey::RSA.new  File.read("#{name.pem}")
    public_key_material=rsa_key.public_key
  end
  
  
  
end
end
