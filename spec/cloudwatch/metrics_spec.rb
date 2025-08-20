# spec/cloudwatch/metrics_localstack_spec.rb
require "aws-sdk-cloudwatch"
require "aws_helper_engine/cloudwatch/metrics"

RSpec.describe AwsHelperEngine::CloudWatch::Metrics do
  let(:client) do
    Aws::CloudWatch::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:metrics) { described_class.new(client) }

  describe "#fetch" do
    before do
      # Send a test metric to LocalStack
      client.put_metric_data(
        namespace: "TestNamespace",
        metric_data: [{ metric_name: "CPUUtilization", value: 50 }]
      )
    end

    it "returns the last average value of a metric" do
      result =
        metrics.fetch(namespace: "TestNamespace", metric_name: "CPUUtilization")
      expect(result).to eq(50)
    end
  end
end
