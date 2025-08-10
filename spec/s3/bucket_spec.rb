require "aws-sdk-s3"
require "aws_helper_engine/s3/bucket"

RSpec.describe AwsHelperEngine::S3::Bucket do
  let(:credentials) do
    Aws::Credentials.new("fake_access_key", "fake_secret_key")
  end
  let(:region) { "us-east-1" }
  let(:bucket_name) { "test-bucket-#{SecureRandom.hex(4)}" }
  let(:key) { "test-key.txt" }
  let(:body) { "Hello, world!" }
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
  describe "controle object" do
    before { bucket_helper.create_bucket(bucket_name, acl: "private") }

    it "#put_object uploads successfully" do
      object = OpenStruct.new(key: key, body: body)
      respo = bucket_helper.put_object(bucket_name, object)
      expect(respo).to eq("Uploaded successfully.")
    end
    it "#get_object downloads successfully" do
      object = OpenStruct.new(key: key, body: body)
      bucket_helper.put_object(bucket_name, object)
      file_path = "/tmp/#{key}"
      bucket_helper.get_object(
        bucket_name: bucket_name,
        key: key,
        response_target: file_path
      )
      expect(File.read(file_path)).to eq(body)
    end
    it "#delete_object removes object" do
      object = OpenStruct.new(key: key, body: body)
      bucket_helper.put_object(bucket_name, object)
      expect(bucket_helper.delete_object(bucket_name, key)).to be_truthy
    end

    it "#object_exists? returns true for existing object" do
      object = OpenStruct.new(key: key, body: body)
      bucket_helper.put_object(bucket_name, object)
      expect(bucket_helper.object_exists?(bucket_name, key)).to be true
    end

    it "#object_exists? returns false for missing object" do
      expect(bucket_helper.object_exists?(bucket_name, "nope.txt")).to be false
    end
  end
  describe "bucket existence check" do
    it "returns true if bucket exists" do
      bucket_helper.create_bucket(bucket_name, acl: "private")
      expect(bucket_helper.bucket_exists?(bucket_name)).to be true
    end

    it "returns false if bucket does not exist" do
      expect(bucket_helper.bucket_exists?("missing-bucket")).to be false
    end
  end
end
