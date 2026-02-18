# typed: strict

module Users
  class FollowButtonComponent < ApplicationComponent
    sig { params(user: User, current_user: T.nilable(User)).void }
    def initialize(user:, current_user:)
      @user = user
      @current_user = current_user
    end

    private

    sig { returns(User) }
    attr_reader :user

    sig { returns(T.nilable(User)) }
    attr_reader :current_user

    sig { returns(T::Boolean) }
    def render?
      current_user.present? && current_user != user
    end

    sig { returns(T::Boolean) }
    def following?
      return false unless current_user
      T.must(current_user).follow?(user)
    end

    sig { returns(String) }
    def dom_id_value
      "follow-button-for-user-#{user.id}"
    end

    sig { returns(T.nilable(String)) }
    def unfollow_path
      return nil unless current_user
      relationship = T.must(current_user).active_relationships.find { |v| v.follower_id == user.id }
      relationship ? helpers.relationship_path(relationship) : nil
    end
  end
end
