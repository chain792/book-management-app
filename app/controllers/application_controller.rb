class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    redirect_to login_path(return: true), warning: t("defaults.message.require_login")
  end
end
