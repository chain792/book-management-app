class OauthsController < ApplicationController
  skip_before_action :require_login

  def create
    user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, danger: 'ログインに失敗しました。メールアドレスが設定されていないか、登録しているメールアドレスがすでに使用されています。'
  else
    auto_login(user)
    redirect_back_or_to root_path, success: t('.success')
  end

  def failure
    redirect_to root_path, danger: t('.fail')
  end
end
