require 'yaml'

Rails.application.config.middleware.use OmniAuth::Builder do

SETUP_PROC = lambda do |env|
  request = Rack::Request.new(env)
  config_file =  YAML.load_file("domains.yml")

  configs = config_file["domains"][request.env["SERVER_NAME"]]
  env['omniauth.strategy'].options[:client_id] =  configs["sso_client_id"]
  env['omniauth.strategy'].options[:client_secret] =  configs["sso_client_secret"]
  env['omniauth.strategy'].options[:scope] = 'user'
end

  provider :githubber, setup: SETUP_PROC
end
OmniAuth.config.logger = Rails.logger
