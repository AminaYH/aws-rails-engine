# spec/cloudwatch/alarms_localstack_spec.rb
require "aws-sdk-cloudwatch"
require "aws_helper_engine/cloudwatch/alarms"

RSpec.describe AwsHelperEngine::CloudWatch::Alarms do
  let(:client) do
    Aws::CloudWatch::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:alarms) { described_class.new(client) }

  describe "#create_alarm and #delete_alarm" do
    it "creates and deletes an alarm" do
      alarms.create_alarm(
        alarm_name: "HighCPU",
        metric_name: "CPUUtilization",
        namespace: "TestNamespace",
        threshold: 80,
        comparison_operator: "GreaterThanThreshold"
      )

      response = client.describe_alarms(alarm_names: ["HighCPU"])
      expect(response.metric_alarms.map(&:alarm_name)).to include("HighCPU")

      alarms.delete_alarm("HighCPU")
      response = client.describe_alarms(alarm_names: ["HighCPU"])
      expect(response.metric_alarms).to be_empty
    end
  end
end
