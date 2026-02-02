# typed: strict

class HeaderComponent < ApplicationComponent
  sig { params(current_user: T.nilable(User)).void }
  def initialize(current_user:)
    @current_user = current_user
  end

  private

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { returns(T::Boolean) }
  def authenticated?
    current_user.present?
  end
end
