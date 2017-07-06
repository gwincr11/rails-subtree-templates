Rails.application.config.middleware.use OmniAuth::Builder do
  provider :githubber, '383954ae4598f7825afe', 'f47d16c996af407b884a8b899d0bc5d0ac9d1242', {
    :scope => 'user'
  }
end
OmniAuth.config.logger = Rails.logger
