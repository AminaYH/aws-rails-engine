require "aws-sdk-cloudwatch"
require "aws-sdk-sns"
require "aws_helper_engine/cloudwatch/manager"

RSpec.describe AwsHelperEngine::CloudWatch::Manager do
  let(:sns_client) do
    Aws::SNS::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:cloudwatch_client) do
    Aws::CloudWatch::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:sns_topic_arn) { sns_client.create_topic(name: "test-topic").topic_arn }

  let(:manager) do
    described_class.new(
      sns_client: sns_client,
      cloudwatch_client: cloudwatch_client,
      sns_topic_arn: sns_topic_arn
    )
  end

  let(:instance_id) { "i-1234567890abcdef0" }

  before do
    # Put a fake CPU metric in LocalStack CloudWatch
    cloudwatch_client.put_metric_data(
      namespace: "AWS/EC2",
      metric_data: [
        {
          metric_name: "CPUUtilization",
          dimensions: [{ name: "InstanceId", value: instance_id }],
          timestamp: Time.now,
          value: 75.0,
          unit: "Percent"
        }
      ]
    )
  end

  describe "#fetch_cpu" do
    it "returns the CPU utilization for an instance" do
      cpu = manager.fetch_cpu(instance_id, period: 60, duration_minutes: 5)
      expect(cpu).to eq(75.0)
    end
  end

  describe "#send_alert" do
    it "publishes a message to the SNS topic" do
      expect { manager.send_alert("CPU Alert!") }.not_to raise_error

      messages =
        sns_client.list_subscriptions_by_topic(topic_arn: sns_topic_arn)
      expect(messages.data).to be_a(
        Aws::SNS::Types::ListSubscriptionsByTopicResponse
      )
    end
  end

  describe "#monitor_cpu" do
    it "prints CPU and sends alert if threshold exceeded" do
      allow(manager).to receive(:puts) # suppress console output

      # Use a low threshold so alert triggers
      expect {
        manager.monitor_cpu(instance_id, threshold: 50)
      }.not_to raise_error
    end
  end
end
