# typed: strict

module Shared
  class LikeButtonComponent < ApplicationComponent
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
    def liked?
      return false unless current_user
      T.must(current_user).like?(book)
    end

    sig { returns(String) }
    def dom_id_value
      helpers.dom_id(book, :like_button)
    end

    sig { returns(Integer) }
    def likes_count
      book.likes.length
    end

    sig { returns(T::Boolean) }
    def show_count?
      likes_count > 0
    end

    sig { returns(T.nilable(String)) }
    def unlike_path
      return nil unless current_user
      like = T.must(current_user).likes.find { |v| v.book_id == book.id }
      like ? helpers.like_path(like) : nil
    end
  end
end
