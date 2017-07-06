class SessionsController < ApplicationController

  def create
    @user = User.find_for_githubber_oauth(omniauth_info)

    puts omniauth_info
    if @user && @user.persisted?
      # This method stores params[:browser_session_id] to the session for later verification.
      # This value is only sent to GitHub owned applications.
      github_sso_session_store!
      self.current_user = @user
      redirect_to root_path
    else
      render status: 403, text: 'Auth Failed'
    end
  end

  def logout
    reset_session
    redirect_to 'https://github.com'
  end

  private

  def omniauth_info
    request.env['omniauth.auth']
  end
end
