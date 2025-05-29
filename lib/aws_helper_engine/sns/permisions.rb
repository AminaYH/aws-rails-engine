require "aws-sdk-sns"

module AwsHelperEngine
  module Sns
    class Permissions
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def add_permission(topic_arn:, label:, aws_account_id: [], action_name: [])
        @client.add_permission({
          topic_arn: topic_arn,
          label: label,
          aws_account_id: aws_account_id,
          action_name: action_name
        })
      end

      def delete_permission(topic_arn:, label:)
        @client.remove_permission({
          topic_arn: topic_arn,
          label: label
        })
      end

      def confirm_subscription(topic_arn:, token:, authenticate_on_unsubscribe:)
        @client.confirm_subscription({
          topic_arn: topic_arn,
          token: token,
          authenticate_on_unsubscribe: authenticate_on_unsubscribe
        })
      end

      def list_subscriptions(next_token:)
        @client.list_subscriptions({
          next_token: next_token
        })
      end

      def list_subscriptions_by_topic(topic_arn:, next_token:)
        @client.list_subscriptions_by_topic({
          topic_arn: topic_arn,
          next_token: next_token
        })
      end


    end
    
  end
end
