require 'aws-sdk-ec2'
module aws_helper_engine 
 module Ec2
  class client
    def initialize(region: 'us-east-1')
    @client = Aws::EC2::Client.new(region: region)
    end
    
  end
 end
end