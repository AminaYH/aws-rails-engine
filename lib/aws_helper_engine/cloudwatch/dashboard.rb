require "aws-sdk-cloudwatch"
module AwsHelperEngine
  module CloudWatch
    class Dashboard
      def initialize(client)
        @cloudwatch = client
      end

      def create_dashboard(name:, widgets:)
        @cloudwatch.put_dashboard(
          dashboard_name: name,
          dashboard_body: widgets.to_json
        )
      end
    end
  end
end
