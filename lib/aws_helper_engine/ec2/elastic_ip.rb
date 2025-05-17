# frozen_string_literal: true
require 'aws-sdk-ec2'
require 'logger'
module AwsHelperEngine
  module Ec2

class ElasticIP
  def initialize

  end
    end

  def allocate_elastic_ip_address(ec2_client)
    response = ec2_client.allocate_address(domain: 'vpc')
    response.allocation_id
  rescue StandardError => e
    puts "Error allocating Elastic IP address: #{e.message}"
    'Error'
  end
def associate_elastic_ip_address_with_instance(
  ec2_client,
  allocation_id,
  instance_id
)
  response = ec2_client.associate_address(
    allocation_id: allocation_id,
    instance_id: instance_id
  )
  response.association_id
rescue StandardError => e
  puts "Error associating Elastic IP address with instance: #{e.message}"
  'Error'
end


end

end
