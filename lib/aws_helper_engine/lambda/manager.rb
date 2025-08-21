require "aws-sdk-lambda"

module AwsHelperEngine
  module Lambda
    class Manager
      def initialize(client)
        @lambda = client
      end
      def deploy(script, function_name, role_arn)
        begin
          @lambda.get_function(function_name: function_name)
          @lambda.update_function_code(
            function_name: function_name,
            zip_file: script.zip_file
          )
        rescue Aws::Lambda::Errors::ResourceNotFoundException
          @lambda.create_function(
            function_name: function_name,
            runtime: "ruby2.7",
            role: role_arn,
            handler: "hello.lambda_handler",
            code: {
              zip_file: script.zip_file
            }
          )
        rescue Aws::Lambda::Errors::InternalError,
               Aws::Lambda::Errors::ResourceConflictException => e
          warn "LocalStack InternalError ignored: #{e.message}"
        end
      end

      # Invoke function
      def invoke(function_name, payload = {})
        resp =
          @lambda.invoke(function_name: function_name, payload: payload.to_json)
        JSON.parse(resp.payload.string)
      end

      private

      def function_exists?(function_name)
        @lambda.get_function(function_name: function_name)
        true
      rescue Aws::Lambda::Errors::ResourceNotFoundException
        false
      end

      def default_handler(script)
        base = File.basename(script.path, ".*")
        script.language == "js" ? "#{base}.handler" : "#{base}.lambda_handler"
      end
    end
  end
end
