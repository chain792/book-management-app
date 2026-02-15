# typed: strict

class ProfileHeaderComponent < ApplicationComponent
  sig { params(user: User).void }
  def initialize(user:)
    @user = user
  end

  private

  sig { returns(User) }
  attr_reader :user

  sig { returns(String) }
  def follower_count
    user.followers.length.to_s
  end

  sig { returns(String) }
  def following_count
    user.followings.length.to_s
  end
end
