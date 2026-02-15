# typed: true
class ApplicationController < ActionController::Base
  extend T::Sig

  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :success, :info, :warning, :danger

  private

  sig { returns(String) }
  def after_authentication_url
    session.delete(:return_to_after_authenticating) || profile_path
  end
end
