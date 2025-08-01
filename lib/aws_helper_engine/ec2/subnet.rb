# lib/aws_helper_engine/ec2/subnet.rb
require "aws-sdk-ec2"

module AwsHelperEngine
  module EC2
    class Subnet
      def initialize(id, name, client, options = {}, region = "us-west-2")
        @name = name
        @client = client
        @vpc_id = id
        @cidr_block = options[:cidr_block]
        @dry_run = options[:dry_run] || false
        @id = nil
      end

      def create(options = {})
        params = {
          vpc_id: @vpc_id,
          cidr_block: options[:cidr_block] || @cidr_block
        }

        # Optional parameters
        %i[
          availability_zone
          availability_zone_id
          ipv_6_cidr_block
          ipv_4_ipam_pool_id
          ipv_4_netmask_length
          ipv_6_ipam_pool_id
          ipv_6_netmask_length
        ].each { |key| params[key] = options[key] if options[key] }

        params[:dry_run] = @dry_run unless options[:dry_run].nil?

        if options[:tags]
          params[:tag_specifications] = [
            { resource_type: "subnet", tags: options[:tags] }
          ]
        end

        response = @client.create_subnet(params)
        @id = response.subnet.subnet_id
        response
      end

      def delete_subnet
        raise "Subnet not created yet" unless @id

        @client.delete_subnet(subnet_id: @id, dry_run: @dry_run)
      end
    end
  end
end
