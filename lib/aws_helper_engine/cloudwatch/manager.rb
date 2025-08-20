require "aws-sdk-cloudwatch"
require "aws-sdk-sns"
module AwsHelperEngine
  module CloudWatch
    class Manager
      attr_reader :sns_client, :cloudwatch, :sns_topic_arn

      def initialize(sns_client:, cloudwatch_client:, sns_topic_arn: nil)
        @cloudwatch = cloudwatch_client
        @sns_client = sns_client
        @sns_topic_arn = sns_topic_arn
      end

      def fetch_cpu(instance_id, period: 300, duration_minutes: 10)
        end_time = Time.now
        start_time = end_time - duration_minutes * 60

        resp =
          cloudwatch.get_metric_statistics(
            namespace: "AWS/EC2",
            metric_name: "CPUUtilization",
            dimensions: [{ name: "InstanceId", value: instance_id }],
            start_time: start_time,
            end_time: end_time,
            period: period,
            statistics: ["Average"]
          )

        resp.datapoints.empty? ? 0 : resp.datapoints.last.average
      end

      def send_alert(message)
        return unless sns_topic_arn

        sns_client.publish(topic_arn: sns_topic_arn, message: message)
      end

      def monitor_cpu(instance_id, threshold: 80)
        cpu = fetch_cpu(instance_id)
        puts "CPU for #{instance_id}: #{cpu}%"

        if cpu > threshold
          send_alert(
            "CPU Alert for #{instance_id}: #{cpu}% exceeds #{threshold}%"
          )
        end
      end
    end
  end
end
