class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:follower_id])
    current_user.follow(@user)
  end

  def destroy
    @user = current_user.active_relationships.find(params[:id]).follower
    current_user.unfollow(@user)
  end
end
