# frozen_string_literal: true
require "rspec"
$LOAD_PATH.unshift File.expand_path("../../../../lib", __FILE__)
require "aws_helper_engine/ec2/client"
require "aws_helper_engine/ec2/ec2_manager" # Make sure this is required too

RSpec.describe AwsHelperEngine::EC2::Client do
  before do
    Aws.config.update(
      credentials: Aws::Credentials.new("fake_access_key", "fake_secret_key"),
      region: "us-east-1",
      endpoint: "http://localhost:4566"
    )
  end

  let(:wrapper) do
    described_class.new(region: "us-east-1", stub_responses: true)
  end
  let(:manager) { AwsHelperEngine::EC2::EC2Manager.new(wrapper.client) }

  it "initializes an EC2 client" do
    expect(wrapper.client).to be_an_instance_of(Aws::EC2::Client)
  end

  it "creates an EC2 instance and returns an Aws::EC2::Types::Instance object" do
    # Stub the response for run_instances
    fake_instance_id = "i-1234567890abcdef0"
    wrapper.client.stub_responses(
      :run_instances,
      instances: [
        {
          instance_id: fake_instance_id,
          instance_type: "t2.micro",
          public_ip_address: "1.2.3.4",
          public_dns_name: "ec2-1-2-3-4.compute-1.amazonaws.com"
        }
      ]
    )

    instance =
      manager.create_instance(
        image_id: "ami-12345678",
        instance_type: "t2.micro"
      )

    expect(instance).to be_a(Aws::EC2::Types::Instance)
    expect(instance.instance_id).to eq(fake_instance_id)
  end
  it "list all EC2 instances" do
    instances = manager.list_instances
    instances.each { |i| expect(i).to be_a(Aws::EC2::Types::Instance) }
  end
end
