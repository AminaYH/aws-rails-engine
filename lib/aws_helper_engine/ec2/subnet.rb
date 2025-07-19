require "aws-sdk-ec2"
module AwsHelperEngine
  module Ec2
    class Subnet
      def initialize(id, options = {}, region)
        @name = name
        @client = Aws::EC2.client.new(region)
        @vpc_id = id
        @cidr_block = options[:cidr_block]
      end
    end
    #only ipv4 stil i didnt add ipv6
    def create(options = {})
      params = { vpc_id: @vpc_id, cidr_block: options[:cidr_block] }

      # Optional params
      params[:availability_zone] = options[:availability_zone] if options[
        :availability_zone
      ]
      params[:availability_zone_id] = options[:availability_zone_id] if options[
        :availability_zone_id
      ]
      params[:ipv_6_cidr_block] = options[:ipv_6_cidr_block] if options[
        :ipv_6_cidr_block
      ]
      params[:ipv_4_ipam_pool_id] = options[:ipv_4_ipam_pool_id] if options[
        :ipv_4_ipam_pool_id
      ]
      params[:ipv_4_netmask_length] = options[:ipv_4_netmask_length] if options[
        :ipv_4_netmask_length
      ]
      params[:ipv_6_ipam_pool_id] = options[:ipv_6_ipam_pool_id] if options[
        :ipv_6_ipam_pool_id
      ]
      params[:ipv_6_netmask_length] = options[:ipv_6_netmask_length] if options[
        :ipv_6_netmask_length
      ]
      params[:dry_run] = options[:dry_run] unless options[:dry_run].nil?

      if options[:tags]
        params[:tag_specifications] = [
          { resource_type: "subnet", tags: options[:tags] }
        ]
      end
      @client.create_subnet(params)
    end
    def delete_subnet(options = {})
      @client.delete_subnet(subnet_id: @id, dry_run: @dry_run)
    end
  end
end
