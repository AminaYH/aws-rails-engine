# frozen_string_literal: true

require "rspec"
require "aws-sdk-ec2"
require "aws_helper_engine/ec2/elastic_ip"

RSpec.describe AwsHelperEngine::EC2::ElasticIP do
  let(:client) { Aws::EC2::Client.new(stub_responses: true) }
  let(:elastic_ip_helper) { described_class.new }

  describe "#allocate_elastic_ip_address" do
    it "returns the allocation ID when successful" do
      client.stub_responses(
        :allocate_address,
        allocation_id: "eipalloc-12345678"
      )

      result = elastic_ip_helper.allocate_elastic_ip_address(client)
      expect(result).to eq("eipalloc-12345678")
    end

    it "returns 'Error' when an exception is raised" do
      client.stub_responses(:allocate_address, StandardError.new("failed"))
      expect {
        elastic_ip_helper.allocate_elastic_ip_address(client)
      }.to output(/Error allocating Elastic IP address: failed/).to_stdout
      expect(elastic_ip_helper.allocate_elastic_ip_address(client)).to eq(
        "Error"
      )
    end
  end

  describe "#associate_elastic_ip_address_with_instance" do
    it "returns the association ID when successful" do
      client.stub_responses(
        :associate_address,
        association_id: "eipassoc-87654321"
      )

      result =
        elastic_ip_helper.associate_elastic_ip_address_with_instance(
          client,
          "eipalloc-12345678",
          "i-1234567890abcdef0"
        )

      expect(result).to eq("eipassoc-87654321")
    end

    it "returns 'Error' when an exception is raised" do
      client.stub_responses(
        :associate_address,
        StandardError.new("associate failed")
      )
      expect {
        elastic_ip_helper.associate_elastic_ip_address_with_instance(
          client,
          "eipalloc-xxx",
          "i-xxx"
        )
      }.to output(
        /Error associating Elastic IP address with instance: associate failed/
      ).to_stdout

      result =
        elastic_ip_helper.associate_elastic_ip_address_with_instance(
          client,
          "eipalloc-xxx",
          "i-xxx"
        )
      expect(result).to eq("Error")
    end
  end
end
