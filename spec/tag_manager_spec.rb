# spec/tag_manager_spec.rb
require "rspec"
require "aws-sdk-ec2"
require "aws_helper_engine/ec2/tag_manager"

RSpec.describe AwsHelperEngine::EC2::TagManager do
  let(:client) { Aws::EC2::Client.new(stub_responses: true) }
  let(:resource_id) { "i-1234567890abcdef0" }
  let(:key) { "Environment" }
  let(:value) { "Development" }

  describe "#create" do
    it "creates a tag with key and value" do
      tag_manager = described_class.new(resource_id, client, key, value)
      expect { tag_manager.create }.not_to raise_error
    end

    it "raises error if key or value is missing" do
      tag_manager = described_class.new(resource_id, client)
      expect { tag_manager.create }.to raise_error(
        "Key and value must be provided"
      )
    end
  end

  describe "#delete" do
    it "deletes a tag by key" do
      tag_manager = described_class.new(resource_id, client, key)
      expect { tag_manager.delete }.not_to raise_error
    end

    it "raises error if key is missing" do
      tag_manager = described_class.new(resource_id, client)
      expect { tag_manager.delete }.to raise_error("Key must be provided")
    end
  end

  describe "#list" do
    it "lists tags for a resource" do
      client.stub_responses(
        :describe_tags,
        {
          tags: [
            { key: "Environment", value: "Dev" },
            { key: "Project", value: "AppX" }
          ]
        }
      )

      tag_manager = described_class.new(resource_id, client)
      tags = tag_manager.list

      expect(tags).to contain_exactly(
        { key: "Environment", value: "Dev" },
        { key: "Project", value: "AppX" }
      )
    end
  end
end
