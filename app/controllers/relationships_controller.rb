# typed: true

class RelationshipsController < ApplicationController
  extend T::Sig

  def create
    @user = User.find(params[:follower_id])
    current_user.follow(@user)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @user = current_user.active_relationships.find(params[:id]).follower
    current_user.unfollow(@user)
    respond_to do |format|
      format.turbo_stream
    end
  end
end
