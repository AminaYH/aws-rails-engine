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

def get_topic_attributes(topic_arn:)
  @client.get_topic_attributes(topic_arn: topic_arn)
end
def set_topic_attributes(topic_arn:, attribute_name:, attribute_value:)
  @client.set_topic_attributes({
    topic_arn: topic_arn,
    attribute_name: attribute_name,
    attribute_value: attribute_value
  })
end
def get_subscription_attributes(subscription_arn:)
  @client.get_subscription_attributes(subscription_arn: subscription_arn)
end
def set_subscription_attributes(subscription_arn:, attribute_name:, attribute_value:)
  @client.set_subscription_attributes({
    subscription_arn: subscription_arn,
    attribute_name: attribute_name,
    attribute_value: attribute_value
  })
end


    end
    
  end
end
