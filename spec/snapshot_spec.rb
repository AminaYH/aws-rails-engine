# spec/snapshoot_spec.rb

require "rspec"
require "aws-sdk-ec2"
require "aws_helper_engine/ec2/snapshot"

RSpec.describe AwsHelperEngine::Ec2::Snapshoot do
  let(:volume_id) { "vol-0123456789abcdef0" }
  let(:region) { "us-west-2" }
  let(:client) { Aws::EC2::Client.new(stub_responses: true) }
  let(:snapshot_id) { "snap-12345678" }
  let(:snapshoot) { described_class.new(volume_id, client, region) }

  describe "#create" do
    it "creates a snapshot and returns its metadata" do
      client.stub_responses(:create_snapshot, snapshot_id: snapshot_id)
      response = snapshoot.create("Test snapshot")

      expect(response[:snapshot_id]).to eq(snapshot_id)
    end
  end

  describe "#delete" do
    it "deletes a created snapshot" do
      client.stub_responses(:create_snapshot, snapshot_id: snapshot_id)
      client.stub_responses(:delete_snapshot, {})

      snapshoot.create("For deletion")
      expect { snapshoot.delete }.not_to raise_error
    end
  end

  describe "#describe" do
    it "describes the snapshot" do
      client.stub_responses(:create_snapshot, snapshot_id: snapshot_id)
      client.stub_responses(
        :describe_snapshots,
        snapshots: [{ snapshot_id: snapshot_id }]
      )

      snapshoot.create("Describe me")
      response = snapshoot.describe

      expect(response.snapshots.first.snapshot_id).to eq(snapshot_id)
    end
  end

  describe "#copy" do
    it "copies the snapshot to another region" do
      client.stub_responses(:create_snapshot, snapshot_id: snapshot_id)
      client.stub_responses(:copy_snapshot, snapshot_id: "copied-snap-001")

      snapshoot.create("Original snapshot")
      response =
        snapshoot.copy(
          description: "Copied snapshot",
          destination_region: "us-east-1"
        )

      expect(response.snapshot_id).to eq("copied-snap-001")
    end
  end

  describe "#delete without create" do
    it "raises an error" do
      expect { snapshoot.delete }.to raise_error("Snapshot not created yet")
    end
  end
end
