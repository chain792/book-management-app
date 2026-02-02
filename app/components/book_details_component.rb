# typed: strict

class BookDetailsComponent < ApplicationComponent
  sig { params(book: Book, current_user: T.nilable(User)).void }
  def initialize(book:, current_user:)
    @book = book
    @current_user = current_user
  end

  private

  sig { returns(Book) }
  attr_reader :book

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { returns(T::Boolean) }
  def own_book?
    current_user&.own?(book) || false
  end

  sig { returns(String) }
  def book_image
    book.book_image_url.presence || "/sample.png"
  end

  sig { returns(String) }
  def authors_list
    (book.authors.pluck(:name).join(", ").presence || "Unknown Author") + " (著)"
  end

  sig { returns(T::Array[Category]) }
  def category_path
    book.category.path.to_a
  end
end
