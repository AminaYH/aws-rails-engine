require "aws-sdk-cloudwatchlogs"
require "securerandom"
require_relative "../../lib/aws_helper_engine/cloudwatch/logs"

RSpec.describe AwsHelperEngine::CloudWatch::Logs do
  let(:client) do
    Aws::CloudWatchLogs::Client.new(
      endpoint: "http://localhost:4566",
      region: "us-east-1",
      access_key_id: "test",
      secret_access_key: "test"
    )
  end

  let(:unique_log_group) { "test-log-group-#{SecureRandom.hex(4)}" }
  let(:logs_manager) { described_class.new(client) }

  before do
    begin
      client.create_log_group(log_group_name: unique_log_group)
    rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
    end

    client.create_log_stream(
      log_group_name: unique_log_group,
      log_stream_name: "stream1"
    )

    client.put_log_events(
      log_group_name: unique_log_group,
      log_stream_name: "stream1",
      log_events: [
        { timestamp: (Time.now.to_f * 1000).to_i, message: "Test log" }
      ]
    )
  end

  describe "#fetch_logs" do
    it "returns log events" do
      events = logs_manager.fetch_logs(log_group_name: unique_log_group)
      expect(events).not_to be_empty
      expect(events.first.message).to eq("Test log")
    end
  end
end
