require "aws-sdk-sns"

module AwsHelperEngine 
module Sns
 class SnsClient
  def initialize(client,topic_name,tags: [])
    @client=client
    @topic_name=topic_name
    @tags = tags

  end
  def create_topic
        resp = @client.create_topic(
          name: @topic_name,
          tags: @tags
        )
        resp.topic_arn
  end
   def subscribe(topic_arn:, protocol:, endpoint:)
        @client.subscribe(
          topic_arn: topic_arn,
          protocol: protocol,     
          endpoint: endpoint      
        )
      end
      #only if you are owner of topic 
  def unsubscribe(subscription_arn:)
  raise ArgumentError, "subscription_arn is required" if subscription_arn.nil? || subscription_arn.empty?

  begin
    @client.unsubscribe(subscription_arn: subscription_arn)
    puts "Successfully unsubscribed from #{subscription_arn}"
  rescue Aws::SNS::Errors::AuthorizationError => e
    puts "Not allowed to unsubscribe. Probably not the owner or insufficient permissions: #{e.message}"
  rescue Aws::SNS::Errors::ServiceError => e
    puts "Failed to unsubscribe due to AWS error: #{e.message}"
  end
end

   def delete_topic(topic_arn:)
        @client.delete_topic(topic_arn: topic_arn)
      end
  def list_topics
        @client.list_topics.topics.map(&:topic_arn)
      end

end
end
end