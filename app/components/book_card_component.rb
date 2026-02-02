# typed: strict

class BookCardComponent < ApplicationComponent
  sig { params(book: Book).void }
  def initialize(book:)
    @book = book
  end

  private

  sig { returns(Book) }
  attr_reader :book

  sig { returns(T.nilable(String)) }
  def book_image
    book.book_image_url.presence || "/sample.png"
  end

  sig { returns(String) }
  def user_name
    book.user.name
  end

  sig { returns(T.nilable(String)) }
  def user_avatar
    book.user.avatar_url.presence || "default_avatar.png"
  end

  sig { returns(String) }
  def category_name
    book.category.name
  end
end
