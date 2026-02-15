# typed: true

class ProfilesController < ApplicationController
  extend T::Sig

  def show
    @books = current_user!.books.includes(:authors, :category)
  end

  def edit
    @user = current_profile_user
  end

  def update
    @user = current_profile_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "プロフィールを更新しました", status: :see_other
    else
      flash.now[:alert] = "プロフィールを更新できませんでした"
      render "edit", status: :unprocessable_content
    end
  end

  private

  sig { returns(User) }
  def current_profile_user
    User.find(current_user!.id)
  end

  sig { returns(ActionController::Parameters) }
  def user_params
    params.require(:user).permit(:name, :email, :avatar, :cached_avatar_data, :introduction)
  end
end
