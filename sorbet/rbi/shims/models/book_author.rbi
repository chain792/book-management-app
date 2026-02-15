# typed: strict

class BookAuthor
  sig { returns(::Book) }
  def book; end

  sig { returns(::Author) }
  def author; end
end
