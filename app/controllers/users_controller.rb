class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[index new create show following follower]
  before_action :set_user, only: %i[show following follower]

  def index
    # createアクションでユーザーの登録に失敗した後にブラウザを更新した場合newアクションにリダイレクトさせる
    redirect_to new_user_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_back_or_to profile_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render 'new'
    end
  end

  def show
    @books = @user.books.includes(:authors, :category)
  end

  def following
    @users = @user.followings
  end

  def follower
    @users = @user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
