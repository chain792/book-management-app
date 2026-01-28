class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :success, :info, :warning, :danger
  before_action :require_authentication

  private

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || profile_path
  end
end
