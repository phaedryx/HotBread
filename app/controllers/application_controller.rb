class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :require_sign_in

protected
  def require_sign_in
    redirect_to(root_path, flash: {notice: "You must sign in first"}) unless current_user
  end

  def current_user
    @current_user ||= User.find_with_id(session[:user_id])
  end
  helper_method :current_user

  def current_user=(user)
    session[:user_id] = user ? user.id : nil
    @current_user = user
  end
end
