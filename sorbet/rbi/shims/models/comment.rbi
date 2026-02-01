# typed: strict

class Comment
  sig { returns(::Book) }
  def book; end

  sig { returns(::User) }
  def user; end
end
