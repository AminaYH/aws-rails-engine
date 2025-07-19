require "aws-sdk-ec2"
module AwsHelperEngine
  module Ec2
    class Vpc
      def initialize(id, options = {}, region)
        @name = name
        @client = Aws::EC2.client.new(region)
        @dry_run = options[:dry_run]
        @tag_specifications =
          tags.empty? ? [] : [{ resource_type: "vpc", tags: tags }]
      end
    end
    #only ipv4 stil i didnt add ipv6
    def create(cidr_block:)
      resp =
        @client.create_vpc(
          {
            cidr_block: cidr_block,
            tag_specifications: @tag_specifications,
            dry_run: @dry_run,
            instance_tenancy: "default"
          }
        )
      puts "VPC Created: #{resp.vpc.vpc_id}"
      resp.vpc
    end
  end
end
