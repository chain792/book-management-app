class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update] 

  def show
    @books = current_user.books.includes(:authors, :category)
  end

  def edit;  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "プロフィールを更新しました", status: :see_other
    else
      flash.now[:alert] = "プロフィールを更新できませんでした"
      render 'edit', status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :cached_avatar_data, :introduction)
  end
end
