# typed: true
class UsersController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access only: %i[index new create show following follower]
  before_action :set_user, only: %i[show following follower]

  sig { void }
  def index
    # createアクションでユーザーの登録に失敗した後にブラウザを更新した場合newアクションにリダイレクトさせる
    redirect_to new_user_path
  end

  sig { void }
  def new
    @user = User.new
  end

  sig { void }
  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to after_authentication_url, notice: 'ユーザー登録が完了しました'
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render 'new', status: :unprocessable_content
    end
  end

  sig { void }
  def show
    @books = @user.books.includes(:authors, :category)
  end

  sig { void }
  def following
    @users = @user.followings
  end

  sig { void }
  def follower
    @users = @user.followers
  end

  private

  sig { returns(ActionController::Parameters) }
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  sig { void }
  def set_user
    @user = User.find(params[:id])
  end
end
