require "aws-sdk-cloudwatch"

module AwsHelperEngine
  module CloudWatch
    class Logs
      def initialize(client)
        @logs = client
      end

      def fetch_logs(log_group_name:, start_time: nil, end_time: nil)
        @logs.filter_log_events(
          log_group_name: log_group_name,
          start_time: start_time ? (start_time.to_i * 1000) : nil,
          end_time: end_time ? (end_time.to_i * 1000) : nil
        ).events
      end
    end
  end
end
