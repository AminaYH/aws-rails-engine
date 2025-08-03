require "aws-sdk-iam"

module AwsHelperEngine
  module IAM
    class Role
      def initialize(client)
        @client = client
      end

      def create(role_name:, assume_role_policy_document:, policies: [])
        role =
          @client.create_role(
            role_name: role_name,
            assume_role_policy_document: assume_role_policy_document,
            description: "IAM role for EC2 instance"
          ).role

        puts "Created role: #{role.role_name} (#{role.arn})"

        # Attach managed policies
        policies.each do |policy_arn|
          @client.attach_role_policy(
            role_name: role_name,
            policy_arn: policy_arn
          )
          puts "Attached policy: #{policy_arn}"
        end

        role
      end
    end
  end
end
