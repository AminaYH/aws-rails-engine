require "aws-sdk-s3"
require "../aws_helper_engine/s3/credentials"

RSpec.describe AwsHelperEngine::S3::Credentials do
  before do
    Aws.config.update(
      credentials: Aws::Credentials.new("fake_access_key", "fake_secret_key"),
      region: "us-east-1",
      endpoint: "http://localhost:4566"
    )
  end
  describe "credials" do
    it "initiliaze crediatials" do
      access_key_id = "fake_access_key"
      secret_access_key = "fake_secret_key"
      session_token = "fake_session_tocken"
      credentials =
        described_class.new(access_key_id, secret_access_key, session_token)
      expect(credentials).to be_a(described_class)
    end
  end
end
