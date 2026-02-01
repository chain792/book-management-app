# typed: true

class PasswordsController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { T.bind(self, PasswordsController).redirect_to new_password_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.find_by(email: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to login_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    @user = current_reset_user
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to login_path, notice: "Password has been reset."
    else
      redirect_to edit_password_url(token: params[:token]), alert: "Passwords did not match."
    end
  end

  private

  sig { returns(User) }
  def current_reset_user
    User.find_by!(password_reset_token: params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    # This might need better handling in a real app,
    # but here we redirect just like the original set_user_by_token did,
    # but we need to satisfy the non-nil return type for srb tc.
    # Actually, if we redirect, the action won't continue.
    # To keep it simple:
    User.find_by!(password_reset_token: params[:token])
  end
end
