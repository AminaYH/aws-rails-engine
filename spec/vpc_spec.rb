require "rspec"
require "aws-sdk-ec2"
require "aws_helper_engine/ec2/vpc"
RSpec.describe AwsHelperEngine::EC2::Vpc do
  describe "#create" do
    let(:client) { Aws::EC2::Client.new(stub_responses: true) }
    let(:vpc_id) { "vpc-12345678" }
    let(:vpc) { described_class.new("my_vpc", client, { dry_run: false }) }
    it " create vpc" do
      client.stub_responses(:create_vpc, { vpc: { vpc_id: vpc_id } })
      response =
        vpc.create(
          cidr_block: "10.0.0.0/24",
          options: {
            resource_type: "vpc",
            tags: []
          }
        )
      expect(response.vpc_id).to eq(vpc_id)
    end
  end
end
