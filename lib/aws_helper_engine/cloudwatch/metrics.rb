require "aws-sdk-cloudwatch"

module AwsHelperEngine
  module CloudWatch
    class Metrics
      def initialize(client)
        @cloudwatch = client
      end

      def fetch(
        namespace:,
        metric_name:,
        dimensions: [],
        period: 300,
        duration_minutes: 10,
        statistics: ["Average"]
      )
        end_time = Time.now
        start_time = end_time - duration_minutes * 60

        resp =
          @cloudwatch.get_metric_statistics(
            namespace: namespace,
            metric_name: metric_name,
            dimensions: dimensions,
            start_time: start_time,
            end_time: end_time,
            period: period,
            statistics: statistics
          )

        resp.datapoints.empty? ? 0 : resp.datapoints.last.average
      end
    end
  end
end
