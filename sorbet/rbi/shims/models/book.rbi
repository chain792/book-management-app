# typed: strict

class Book
  sig { returns(::User) }
  def user; end

  sig { returns(::Category) }
  def category; end
end
