# /home/amina/Desktop/aws_helper_engine/spec/fixtures/hello.rb
def handler(event:, context:)
  { statusCode: 200, body: "Hello, Lambda!" }
end
