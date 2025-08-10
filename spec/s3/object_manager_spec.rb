require "aws-sdk-s3"
require "aws_helper_engine/s3/object_manager"

RSpec.describe AwsHelperEngine::S3::ObjectManager do
  let(:credentials) do
    Aws::Credentials.new("fake_access_key", "fake_secret_key")
  end
  let(:region) { "us-east-1" }
  let(:bucket_name) { "test-bucket-#{SecureRandom.hex(4)}" }
  let(:key) { "test-key.txt" }
  let(:body) { "Hello, world!" }
  let(:file_path) do
    "/home/amina/Desktop/aws_helper_engine/test/fixtures/files/test.txt"
  end
  let(:destination_path) do
    "    /home/amina/Desktop/aws_helper_engine/test/fixtures/files/test-1.txt
"
  end
  before do
    @client =
      Aws::S3::Client.new(
        credentials: credentials,
        region: region,
        endpoint: "http://localhost:4566",
        force_path_style: true
      )
    @resource = Aws::S3::Resource.new(client: @client)
    begin
      @client.create_bucket(bucket: bucket_name)
    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
    end
  end

  let(:object_manager_helper) do
    described_class.new(@client, @resource, region: region)
  end
  describe "put file in bucket" do
    let!(:uploaded_key) do
      object_manager_helper.upload_file(bucket_name, file_path, key)
    end

    it "#upload file" do
      expect(uploaded_key).to be_a(String)
      expect(uploaded_key).to end_with(key)
    end

    it "#download file" do
      response =
        object_manager_helper.download_file(
          bucket_name,
          uploaded_key,
          destination_path.strip
        )
      expect(response).to be_a(String)
      expect(response).to end_with(File.basename(destination_path.strip))
    end
  end
end
