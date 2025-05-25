require 'aws-sdk-ec2'

module AwsHelperEngine
  module Ec2
    class snapshoot 
      def initialize(volume_id,client)
       @volume_id=volume_id
       @client=client
       @dry_run=false
       @resp = nil

      end
      def create(description)
         @resp=@client.create_snapshot(description,@volume_id)
        
        @resp
      end
      def delete
        raise 'Snapshot not created yet' unless @response


        resp = client.delete_snapshot({ @resp.snapshot_id, dry_run })
      end
      def describe
       @client.describe_snapshot(@resp.snapshot_id)
      end
      def describe_
    end
     