require "rspec"
require "aws-sdk-iam"
require "aws_helper_engine/iam/iam_role"

RSpec.describe AwsHelperEngine::IAM::Role do
  describe "#create" do
    let(:client) { Aws::IAM::Client.new(stub_responses: true) }
    let(:role_name) { "MyEC2Role" }
    let(:policy_arn) do
      "arn:aws:iam
    ::aws:policy/AmazonSSMManagedInstanceCore"
    end
    let(:assume_policy_doc) do
      {
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Principal: {
              Service: "ec2.amazonaws.com"
            },
            Action: "sts:AssumeRole"
          }
        ]
      }.to_json
      subject { described_class.new(client) }

      before do
        client.stub_responses(
          :create_role,
          role: {
            role_name: role_name,
            arn: "arn:aws:iam::123456789012:role/#{role_name}"
          }
        )
        client.stub_responses(:attach_role_policy, {})
      end
      it "creates an IAM role and attaches a policy" do
        role =
          subject.create(
            role_name: role_name,
            assume_role_policy_document: assume_policy_doc,
            policies: [policy_arn]
          )

        expect(role.role_name).to eq(role_name)
        expect(role.arn).to eq("arn:aws:iam::123456789012:role/#{role_name}")
      end
    end
  end
end
