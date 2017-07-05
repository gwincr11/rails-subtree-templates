class User < ApplicationRecord
   def self.find_for_githubber_oauth(access_token, signed_in_resource=nil)
    # Prevents past-GitHubbers from logging into existing accounts they
    # created when they were previously a GitHubber. Also ensures
    # new accounts can't be created unless they are a true GitHubber.
    #return false unless access_token.credentials.github_employee?

    puts 'Here'
    info = access_token.info
    github_id = access_token.uid

    user = where(github_id: github_id).first_or_initialize

    if user
      user.github_authentication_token = access_token.credentials.token
    end

    if user.new_record?
      user.name  = info.name
      user.email = info.email
      user.login = info.nickname
    end

    user.save

    user
  end
end
