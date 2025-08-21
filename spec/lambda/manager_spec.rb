require "aws_helper_engine/lambda/manager"
require "aws_helper_engine/lambda/script"
require "aws-sdk-lambda"
require "json"

RSpec.describe AwsHelperEngine::Lambda::Manager do
  let(:client) do
    Aws::Lambda::Client.new(
      region: "us-east-1",
      endpoint: "http://localhost:4566"
    )
  end

  let(:manager) { described_class.new(client) }

  let(:python_script_path) { File.expand_path("../fixtures/hello.py", __dir__) }
  let(:script) { AwsHelperEngine::Lambda::Script.new(python_script_path) }
  let(:role_arn) { "arn:aws:iam::000000000000:role/lambda-role" }

  before(:each) do
    client.list_functions.functions.each do |f|
      begin
        client.delete_function(function_name: f.function_name)
      rescue Aws::Lambda::Errors::ResourceNotFoundException
      end
    end
  end

  # LocalStack doesn't require waiting; always consider Active
  def wait_for_function_active(client, function_name, timeout: 20)
    return if ENV["LOCALSTACK"] == "1"

    start_time = Time.now
    loop do
      begin
        resp = client.get_function(function_name: function_name)
        return if resp.configuration.state == "Active"
      rescue Aws::Lambda::Errors::ResourceConflictException,
             Aws::Lambda::Errors::InternalError
      end

      if Time.now - start_time > timeout
        raise "Timeout waiting for function to become Active"
      end
      sleep 1
    end
  end

  describe "#deploy" do
    it "creates a new Lambda function if it doesn't exist" do
      expect {
        manager.deploy(script, "hello_lambda", role_arn, runtime: "python3.9")
      }.not_to raise_error

      resp = client.get_function(function_name: "hello_lambda")
      expect(resp.configuration.function_name).to eq("hello_lambda")
      expect(resp.configuration.runtime).to eq("python3.9")
    end

    it "updates Lambda function if it already exists" do
      manager.deploy(script, "hello_lambda", role_arn)

      # Update
      expect {
        manager.deploy(script, "hello_lambda", role_arn)
      }.not_to raise_error

      resp = client.get_function(function_name: "hello_lambda")
      expect(resp.configuration.function_name).to eq("hello_lambda")
    end
  end

  describe "#invoke" do
    it "invokes the Lambda function and returns output" do
      manager.deploy(script, "hello_lambda", role_arn)

      wait_for_function_active(client, "hello_lambda")

      payload = { "name" => "Amina" }
      result = manager.invoke("hello_lambda", payload)
      expect(result).to be_a(Hash)
      expect(result["message"]).to eq("Hello Amina")
    end
  end
end
