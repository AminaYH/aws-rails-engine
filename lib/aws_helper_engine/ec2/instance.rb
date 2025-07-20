# frozen_string_literal: true
require "aws-sdk-ec2"
require "logger"

module AwsHelperEngine
  module EC2
    class Instance
      def initialize(client)
        @client = client
      end
      def instance_started?(instance_id)
        response = @client.describe_instances(instance_ids: [instance_id])

        reservations = response.reservations
        if reservations.any? && reservations[0].instances.any?
          state = reservations[0].instances[0].state.name
          case state
          when "pending"
            puts "Instance is pending. Try again later."
            return false
          when "running"
            puts "The instance is already running."
            return true
          when "terminated"
            puts "Instance is terminated."
            return false
          end
        end

        @client.start_instances(instance_ids: [instance_id])
        @client.wait_until(:instance_running, instance_ids: [instance_id])
        puts "Instance started."
        true
      rescue StandardError => e
        puts "Error starting instance: #{e.message}"
        false
      end
    end
  end
end
