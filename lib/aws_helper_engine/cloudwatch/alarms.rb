require "aws-sdk-cloudwatch"

module AwsHelperEngine
  module CloudWatch
    class Alarms
      def initialize(client)
        @cloudwatch = client
      end

      def create_alarm(
        alarm_name:,
        metric_name:,
        namespace:,
        threshold:,
        comparison_operator:,
        evaluation_periods: 1,
        period: 300,
        statistic: "Average",
        actions: []
      )
        @cloudwatch.put_metric_alarm(
          alarm_name: alarm_name,
          metric_name: metric_name,
          namespace: namespace,
          threshold: threshold,
          comparison_operator: comparison_operator,
          evaluation_periods: evaluation_periods,
          period: period,
          statistic: statistic,
          alarm_actions: actions
        )
      end

      def delete_alarm(alarm_name)
        @cloudwatch.delete_alarms(alarm_names: [alarm_name])
      end
    end
  end
end
