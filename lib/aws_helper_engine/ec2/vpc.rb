require "aws-sdk-ec2"
module AwsHelperEngine
  module EC2
    class Vpc
      def initialize(name, client, options = {})
        @name = name
        @client = client
        @dry_run = options[:dry_run]
      end
      #only ipv4 still i didnt add ipv6
      def create(options = {})
        resp =
          @client.create_vpc(
            {
              cidr_block: options[:cidr_block],
              tag_specifications:
                (
                  if options[:tags].nil? || options[:tags].empty?
                    []
                  else
                    [
                      {
                        resource_type: options[:ressource_type],
                        tags: options[:tags]
                      }
                    ]
                  end
                ),
              dry_run: @dry_run,
              instance_tenancy: "default"
            }
          )
        puts "VPC Created: #{resp.vpc.vpc_id}"
        resp.vpc
      end
    end
  end
end
