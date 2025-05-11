require 'aws-sdk-ec2'

creds = Aws::Credentials.new('AKIA...', 'SECRET...')
client = Aws::EC2::Client.new(region: 'us-east-1', credentials: creds)

puts "Client initialized: #{client.class}"
