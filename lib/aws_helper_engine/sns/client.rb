require "aws-sns-sdk"
module AwsHelperEngine
module Sns
class Client
  

  def initialize(region:"us-east-1", access_key_id: nil, secret_access_key: nil, session_token: nil)
    @client=AWS::SNS::Client.new(
      region: region,
      access_key_id:access_key_id,
      secret_access_key: secret_access_key,
      session_token: session_token
    )
  end
  attr_reader :client


end

end
end