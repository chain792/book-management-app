# typed: strict

module Users
  class CardComponent < ApplicationComponent
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

    sig { returns(String) }
    def avatar_url
      user.avatar_url.presence || "default_avatar.png"
    end

    sig { returns(T.nilable(String)) }
    def introduction_text
      user.introduction&.truncate(80)
    end
  end
end
