class SessionsController < ApplicationController
  skip_before_filter :require_sign_in
  skip_before_filter :verify_authenticity_token

  def create
    auth = Authentication.find_or_create_with_auth(auth_hash)
    self.current_user = auth.user
    redirect_to(dashboard_index_path, flash: {success: "You have signed in successfully"})
  end

  def failure
    redirect_to(root_path, flash: {alert: "Authentication failure"})
  end

  def destroy
    self.current_user = nil
    redirect_to(root_path, flash: {success: "You have signed out successfully"})
  end

private
  def auth_hash
    uid      = request.env['omniauth.auth']['uid']
    provider = request.env['omniauth.auth']['provider']
    name     = request.env['omniauth.auth']['info']['name']
    email    = request.env['omniauth.auth']['info']['email']
    phone    = request.env['omniauth.auth']['info']['phone']

    {uid: uid, provider: provider, name: name, email: email, phone: phone}
  end
end
