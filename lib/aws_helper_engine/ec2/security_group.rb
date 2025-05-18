require 'aws-sdk-ec2'

module AwsHelperEngine
  module Ec2
    class SecurityGroup
      def initialize(vpc_id:, region: 'us-west-2')
        @vpc_id = vpc_id
        @client = Aws::EC2::Client.new(region: region)
      end

      def create(name:, description:, tags: [], ingress_rules: [], egress_rules: [])
        resp = @client.create_security_group({
          group_name: name,
          description: description,
          vpc_id: @vpc_id,
          tag_specifications: tags.empty? ? [] : [{
            resource_type: 'security-group',
            tags: tags
          }]
        })

        group_id = resp.group_id

        unless ingress_rules.empty?
          @client.authorize_security_group_ingress({
            group_id: group_id,
            ip_permissions: ingress_rules
          })
        end

        unless egress_rules.empty?
          @client.authorize_security_group_egress({
            group_id: group_id,
            ip_permissions: egress_rules
          })
        end

        group_id
      end
    end
  end
end
