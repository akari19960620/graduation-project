class ApplicationController < ActionController::Base
  add_flash_types :success, :danger
  before_action :require_login

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern unless Rails.env.test?
  # Changes to the importmap will invalidate the etag for HTML responses
  
  private

  def require_login
    unless current_user
      redirect_to new_login_path, danger: "ログインしてください"
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
