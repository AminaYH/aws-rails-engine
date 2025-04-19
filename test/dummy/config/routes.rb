Rails.application.routes.draw do
  mount AwsHelperEngine::Engine => "/aws_helper_engine"
end
