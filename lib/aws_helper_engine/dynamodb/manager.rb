require "aws-sdk-dynamodb"
module AwsHelperEngine
  module Dynamodb
    class Manager
      def initialize(client: client)
        @client = client
      end
      def list_tables
        paginator = @client.list_tables(limit: 10)
        table_names = []
        paginator.each_page do |page|
          page.table_names.each { |table_name| table_names << table_name }
        end
        if table_names.empty?
          puts "you dont have any table related to this account"
        end
      end
      def exists?(table_name)
        resp = @client.describe_table(table_name: table_name)
      end
    end
  end
end
