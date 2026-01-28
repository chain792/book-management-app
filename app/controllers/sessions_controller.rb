class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create guest_login ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: 'ログインしました'
    else
      redirect_to login_path, alert: 'ログインに失敗しました'
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: 'ログアウトしました', status: :see_other
  end

  def guest_login
    random_value = SecureRandom.alphanumeric(10) + Time.zone.now.to_i.to_s
    @guest_user = User.create(
      name: "GuestUser",
      email: "#{random_value}@example.com",
      password: "password",
      password_confirmation: "password",
      role: :guest
    )
    id = @guest_user.id
    @guest_user.update!(name: "GuestUser_#{id}")
    start_new_session_for(@guest_user)
    redirect_to after_authentication_url, notice: "ゲストとしてログインしました"
  end
end
