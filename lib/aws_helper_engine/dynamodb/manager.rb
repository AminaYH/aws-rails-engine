require "aws-sdk-dynamodb"
module AwsHelperEngine
module dynamodb
  class Manager
    def initialize(Client)
      @client=client
  end
  def list_tables
    paginator = @client.list_tables(limit: 10)
    table_names=[]
    paginator.each_page do |page|
       page.table_names.each do |table_name| 
    table_names << table_name
       end
    end 
    if table_names.empty?
      puts "you dont have any table related to this account"
    end
    

  end
  def exists?(table_name)
   resp= @client.describe_table(table_name: table_name)
  end
end
end