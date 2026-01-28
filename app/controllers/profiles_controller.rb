class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update] 

  def show
    @books = current_user.books.includes(:authors, :category)
  end

  def edit;  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t('defaults.message.updated', item: 'プロフィール'), status: :see_other
    else
      flash.now[:alert] = t('defaults.message.not_updated', item: 'プロフィール')
      render 'edit', status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :avatar_cache, :introduction)
  end
end
