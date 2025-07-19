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
        const response = @client.create_snapshot(description, @volume_id)
        @resp = response.to_h
      end
      def delete
        raise "Snapshot not created yet" unless @response

        resp =
          client.delete_snapshot(
            { snapshot_id: @resp[:snapshot_id], dry_run: @dry_run }
          )
      end
      def describe
        const response = @client.describe_snapshot([@resp.snapshot_id])
        response
      end
      # u need to add describe snapshot with filter and describe multiple snapshot
      def copy(description: string, destination_region: destination_region)
        @client.copy_snapshot(
          description,
          destination_region,
          @region,
          @resp.snapshot_id
        )
      end
    end
  end
end
