# spec/cloudwatch/dashboard_localstack_spec.rb
require "aws-sdk-cloudwatch"
require "aws_helper_engine/cloudwatch/dashboard"

RSpec.describe AwsHelperEngine::CloudWatch::Dashboard do
  let(:client) do
    Aws::CloudWatch::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:dashboard) { described_class.new(client) }

  describe "#create_dashboard" do
    it "creates a dashboard" do
      widgets = [
        {
          type: "metric",
          x: 0,
          y: 0,
          width: 6,
          height: 6,
          properties: {
            metrics: [%w[TestNamespace CPUUtilization]]
          }
        }
      ]

      dashboard.create_dashboard(name: "MyDashboard", widgets: widgets)
      response = client.get_dashboard(dashboard_name: "MyDashboard")
      expect(response.dashboard_name).to eq("MyDashboard")
    end
  end
end
