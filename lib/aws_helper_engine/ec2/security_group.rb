require "aws-sdk-ec2"

module AwsHelperEngine
  module Ec2
    class SecurityGroup
      def initialize(vpc_id:, client:)
        @vpc_id = vpc_id
        @client = client
      end

      def create(
        name:,
        description:,
        tags: [],
        ingress_rules: [],
        egress_rules: []
      )
        tag_specifications =
          tags.empty? ? [] : [{ resource_type: "security-group", tags: tags }]

        response =
          @client.create_security_group(
            group_name: name,
            description: description,
            vpc_id: @vpc_id,
            tag_specifications: tag_specifications
          )

        group_id = response.group_id

        unless ingress_rules.empty?
          @client.authorize_security_group_ingress(
            group_id: group_id,
            ip_permissions: ingress_rules
          )
        end

        unless egress_rules.empty?
          @client.authorize_security_group_egress(
            group_id: group_id,
            ip_permissions: egress_rules
          )
        end

        group_id
      end
    end
  end
end
