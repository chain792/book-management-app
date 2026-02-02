# typed: strict

class CommentComponent < ApplicationComponent
  sig { params(comment: Comment, current_user: T.nilable(User)).void }
  def initialize(comment:, current_user:)
    @comment = comment
    @current_user = current_user
  end

  private

  sig { returns(Comment) }
  attr_reader :comment

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { returns(T::Boolean) }
  def own_comment?
    current_user&.own?(comment) || false
  end

  sig { returns(User) }
  def author
    comment.user
  end
end
