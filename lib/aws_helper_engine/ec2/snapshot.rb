# lib/aws_helper_engine/ec2/snapshoot.rb

require "aws-sdk-ec2"

module AwsHelperEngine
  module Ec2
    class Snapshoot
      def initialize(volume_id, client, region)
        @volume_id = volume_id
        @client = client
        @region = region
        @dry_run = false
        @resp = nil
      end

      def create(description)
        response =
          @client.create_snapshot(
            volume_id: @volume_id,
            description: description,
            dry_run: @dry_run
          )
        @resp = response.to_h
        @resp
      end

      def delete
        raise "Snapshot not created yet" unless @resp

        @client.delete_snapshot(
          snapshot_id: @resp[:snapshot_id],
          dry_run: @dry_run
        )
      end

      def describe
        raise "Snapshot not created yet" unless @resp

        @client.describe_snapshots(snapshot_ids: [@resp[:snapshot_id]])
      end

      def copy(description:, destination_region:)
        raise "Snapshot not created yet" unless @resp

        @client.copy_snapshot(
          source_region: @region,
          source_snapshot_id: @resp[:snapshot_id],
          description: description,
          destination_region: destination_region
        )
      end
    end
  end
end
