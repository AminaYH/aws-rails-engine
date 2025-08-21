require "aws-sdk-lambda"
require "zip"
module AwsHelperEngine
  module Lambda
    class Script
      SUPPORTED_LANGUAGES = {
        ".rb" => "ruby2.7",
        ".py" => "python3.9",
        ".js" => "nodejs18.x"
      }
      attr_reader :path, :language, :runtime

      def initialize(path)
        @path = path
        detect_language
      end

      def detect_language
        ext = File.extname(@path)
        @runtime = SUPPORTED_LANGUAGES[ext]
        raise "Unsupported language: #{ext}" unless @runtime
        @language = ext[1..]
      end

      def content
        File.read(@path)
      end

      # Writes zip to a given file path
      def package(destination)
        Zip::File.open(destination, create: true) do |zip|
          entry_name = File.basename(@path)
          zip.add(entry_name, @path) unless zip.find_entry(entry_name)
        end
      end

      # Returns zip as a binary string for AWS SDK
      def zip_file
        buffer =
          Zip::OutputStream.write_buffer do |out|
            out.put_next_entry(File.basename(@path))
            out.write content
          end
        buffer.string
      end
    end
  end
end
