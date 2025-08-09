require "aws-sdk-s3"
require "aws_helper_engine/s3/bucket"

RSpec.describe AwsHelperEngine::S3::Bucket do
  let(:credentials) do
    Aws::Credentials.new("fake_access_key", "fake_secret_key")
  end
  let(:region) { "us-east-1" }
  let(:bucket_name) { "test-bucket-#{SecureRandom.hex(4)}" }
  before do
    @client =
      Aws::S3::Client.new(
        credentials: credentials,
        region: region,
        endpoint: "http://localhost:4566",
        force_path_style: true
      )
    @ressource = Aws::S3::Resource.new(client: @client)
  end
  let(:bucket_helper) { described_class.new(@client, @ressource, region) }
  describe "create bucket" do
    it "create bucket" do
      bucket = bucket_helper.create_bucket(bucket_name, acl: "private")
      expect(bucket).to be_an_instance_of(Aws::S3::Bucket)
    end
    it "create bucket with emty name" do
      bucket = bucket_helper.create_bucket("", acl: "private")
      expect(bucket).to start_with("Failed to create bucket: ")
    end
  end
  describe "list buckets" do
    it "list buckets" do
      buckets_n = bucket_helper.list_buckets()
      expect(buckets_n).to be_an_instance_of(Integer)
    end
  end
  describe "delete bucket" do
    before { bucket_helper.create_bucket(bucket_name, acl: "private") }
    it "delete bucket" do
      response = bucket_helper.delete_bucket(bucket_name)
      expect(response).to be_a(Aws::EmptyStructure)
    end
    it "delete non existing bucket" do
      response = bucket_helper.delete_bucket("bucket-test")
      expect(response).to be nil
    end
  end
end
