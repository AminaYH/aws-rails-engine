require "aws-sdk-s3"
require "aws_helper_engine/s3/client.rb"

RSpec.describe AwsHelperEngine::S3::Client do
  let(:credentials) do
    Aws::Credentials.new("fake_access_key", "fake_secret_key")
  end
  let(:bucket_name) { "test-bucket" }
  let(:key) { "test-key.txt" }
  let(:body) { "Hello, world!" }
  let(:region) { "us-east-1" }
  before do
    s3 =
      Aws::S3::Client.new(
        credentials: credentials,
        region: "us-east-1",
        endpoint: "http://localhost:4566",
        force_path_style: true
      )
    begin
      s3.create_bucket(bucket: bucket_name)
    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
    end
  end
  before do
    # Update Aws.config for LocalStack
    Aws.config.update(
      region: region,
      endpoint: "http://localhost:4566",
      force_path_style: true,
      credentials: credentials
    )
  end
  let(:client) do
    described_class.new(credentials: credentials, region: "us-east-1")
  end
  describe "put_object" do
    it "uploads an object to the bucket" do
      resp = client.put_object(bucket_name: bucket_name, key: key, body: body)
      expect(resp.context.http_response.status_code).to eq(200)
    end
  end
  describe "get object " do
    before { client.put_object(bucket_name: bucket_name, key: key, body: body) }
    it " get object from bucket" do
      resp = client.get_object(bucket_name: bucket_name, key: key)
      expect(resp.body.read).to eq(body)
    end
  end
  describe "#delete_object" do
    before { client.put_object(bucket_name: bucket_name, key: key, body: body) }

    it "deletes the object from the bucket" do
      resp = client.delete_object(bucket_name: bucket_name, key: key)
      expect(resp.context.http_response.status_code).to eq(204)

      expect {
        client.get_object(bucket_name: bucket_name, key: key)
      }.to raise_error(Aws::S3::Errors::NoSuchKey)
    end
  end
end
