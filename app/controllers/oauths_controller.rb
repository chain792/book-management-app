# typed: true

class OauthsController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access only: %i[create failure]

  def create
    # request.env is untyped in many RBIs, so T.unsafe(request.env) might be needed for find_or_create params
    auth_hash = T.unsafe(request.env)["omniauth.auth"]
    user = User.find_or_create_from_auth_hash!(auth_hash)
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: "ログインに失敗しました。メールアドレスが設定されていないか、登録しているメールアドレスがすでに使用されています。"
  else
    start_new_session_for(user)
    redirect_to after_authentication_url, notice: "ログインしました"
  end

  def failure
    redirect_to root_path, alert: "ログインに失敗しました"
  end
end
