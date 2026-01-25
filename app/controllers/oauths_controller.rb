class OauthsController < ApplicationController
  allow_unauthenticated_access only: %i[create failure]

  def create
    user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, danger: 'ログインに失敗しました。メールアドレスが設定されていないか、登録しているメールアドレスがすでに使用されています。'
  else
    start_new_session_for(user)
    redirect_to after_authentication_url, success: t('.success')
  end

  def failure
    redirect_to root_path, danger: t('.fail')
  end
end
