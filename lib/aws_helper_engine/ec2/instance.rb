# frozen_string_literal: true
require 'aws-sdk-ec2'
require 'logger'

module AwsHelperEngine
  module Ec2
    class Instance


      def initialize(access_key_id:, secret_access_key:, region: 'us-east-1')
        creds = Aws::Credentials.new(access_key_id, secret_access_key)
        @client = Aws::EC2::Client.new(region: region, credentials: creds)
      end
      def instance_started?(ec2_client, instance_id)
        response = ec2_client.describe_instance_status(instance_ids: [instance_id])

        if response.instance_statuses.count.positive?
          state = response.instance_statuses[0].instance_state.name
          case state
          when 'pending'
            puts 'Error starting instance: the instance is pending. Try again later.'
            return false
          when 'running'
            puts 'The instance is already running.'
            return true
          when 'terminated'
            puts 'Error starting instance: ' \
                   'the instance is terminated, so you cannot start it.'
            return false
          end
        end

        ec2_client.start_instances(instance_ids: [instance_id])
        ec2_client.wait_until(:instance_running, instance_ids: [instance_id])
        puts 'Instance started.'
        true
      rescue StandardError => e
        puts "Error starting instance: #{e.message}"
        false
      end
    end

  end
end
