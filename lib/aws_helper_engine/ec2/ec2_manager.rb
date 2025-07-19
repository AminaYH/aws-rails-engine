# frozen_string_literal: true
require "aws-sdk-ec2"
require "logger"
module AwsHelperEngine
  module Ec2
    class EC2Manager
      def initialize(client)
        @client = client
        @logger = Logger.new($stdout)
      end

      def list_instances
        @logger.info("Listing instances")
        instances = fetch_instances
        if instances.empty?
          @logger.info("You have no instances")
        else
          print_instances(instances)
        end
      end
      def fetch_instances
        paginator = @client.describe_instances
        instances = []
        paginator.each_page do |page|
          page.reservations.each do |reservation|
            reservation.instances.each { |instance| instances << instance }
          end
        end
        instances
      end
      def print_instances(instances)
        instances.each do |instance|
          @logger.info("Instance ID: #{instance.instance_id}")
          @logger.info("Instance Type: #{instance.instance_type}")
          @logger.info("Public IP: #{instance.public_ip_address}")
          @logger.info("Public DNS Name: #{instance.public_dns_name}")
          @logger.info("\n")
        end
      end
    end
  end
end
