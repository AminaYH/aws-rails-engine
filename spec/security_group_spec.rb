# frozen_string_literal: true

require "rspec"
require "aws-sdk-ec2"

require "aws_helper_engine/ec2/security_group"

RSpec.describe AwsHelperEngine::Ec2::SecurityGroup do
  let(:vpc_id) { "vpc-12345678" }
  let(:mock_client) { Aws::EC2::Client.new(stub_responses: true) }
  let(:security_group) do
    described_class.new(vpc_id: vpc_id, client: mock_client)
  end

  describe "#create" do
    context "with tags and rules" do
      it "creates a security group and applies ingress and egress rules" do
        mock_client.stub_responses(
          :create_security_group,
          group_id: "sg-abc123"
        )
        mock_client.stub_responses(:authorize_security_group_ingress, {})
        mock_client.stub_responses(:authorize_security_group_egress, {})

        tags = [{ key: "Environment", value: "Test" }]
        ingress_rules = [
          {
            ip_protocol: "tcp",
            from_port: 22,
            to_port: 22,
            ip_ranges: [{ cidr_ip: "0.0.0.0/0" }]
          }
        ]
        egress_rules = [
          { ip_protocol: "-1", ip_ranges: [{ cidr_ip: "0.0.0.0/0" }] }
        ]

        group_id =
          security_group.create(
            name: "MySG",
            description: "Test security group",
            tags: tags,
            ingress_rules: ingress_rules,
            egress_rules: egress_rules
          )

        expect(group_id).to eq("sg-abc123")
      end
    end

    context "with no tags or rules" do
      it "creates a security group with minimal options" do
        mock_client.stub_responses(:create_security_group, group_id: "sg-empty")

        group_id =
          security_group.create(
            name: "EmptyGroup",
            description: "No tags or rules"
          )

        expect(group_id).to eq("sg-empty")
      end
    end
  end
end
