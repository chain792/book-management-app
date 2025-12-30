class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]

  def new
    # 自分で「ログイン or 新規登録」ボタンを押下した場合はsession[:return_to_url]を削除する
    session[:return_to_url] = nil if params[:return].nil?
  end

  def create 
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to profile_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end

  def guest_login
    rondom_value = SecureRandom.alphanumeric(10) + Time.zone.now.to_i.to_s
    @guest_user = User.create(
      name: 'GuestUser',
      email: rondom_value + '@example.com',
      password: 'password',
      password_confirmation: 'password',
      role: :guest
    )
    id = @guest_user.id
    @guest_user.update!(name: "GuestUser_#{id}")
    auto_login(@guest_user)
    redirect_back_or_to profile_path, success: 'ゲストとしてログインしました'
  end
end
