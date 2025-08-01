# spec/subnet_spec.rb

require "rspec"
require "aws-sdk-ec2"
require "aws_helper_engine/ec2/subnet"
RSpec.describe AwsHelperEngine::EC2::Subnet do
  let(:client) { Aws::EC2::Client.new(stub_responses: true) }
  let(:vpc_id) { "vpc-12345678" }
  let(:subnet_id) { "subnet-87654321" }
  let(:name) { "test-subnet" }
  let(:region) { "us-west-2" }

  let(:subnet) { described_class.new(vpc_id, name, client, {}, region) }

  describe "#create" do
    it "creates a subnet and returns response" do
      client.stub_responses(
        :create_subnet,
        { subnet: { subnet_id: subnet_id } }
      )

      response = subnet.create(cidr_block: "10.0.0.0/24")

      expect(response.subnet.subnet_id).to eq(subnet_id)
    end

    it "adds tags when provided" do
      client.stub_responses(
        :create_subnet,
        { subnet: { subnet_id: subnet_id } }
      )

      response =
        subnet.create(
          cidr_block: "10.0.1.0/24",
          tags: [{ key: "Name", value: "MySubnet" }]
        )

      expect(response.subnet.subnet_id).to eq(subnet_id)
    end
  end

  describe "#delete_subnet" do
    it "deletes an existing subnet" do
      client.stub_responses(
        :create_subnet,
        { subnet: { subnet_id: subnet_id } }
      )
      client.stub_responses(:delete_subnet, {})

      subnet.create(cidr_block: "10.0.2.0/24")
      expect { subnet.delete_subnet }.not_to raise_error
    end

    it "raises error if subnet is not created" do
      expect { subnet.delete_subnet }.to raise_error("Subnet not created yet")
    end
  end
end
