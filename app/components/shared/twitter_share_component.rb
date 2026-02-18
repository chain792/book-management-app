# typed: strict

module Shared
  class TwitterShareComponent < ApplicationComponent
    sig { params(book: Book, url: String).void }
    def initialize(book:, url:)
      @book = book
      @url = url
    end

    private

    sig { returns(Book) }
    attr_reader :book

    sig { returns(String) }
    attr_reader :url

    sig { returns(String) }
    def share_url
      "https://twitter.com/intent/tweet?url=#{url}&hashtags=EnginnerBook&text=#{share_text}"
    end

    sig { returns(String) }
    def share_text
      book.body.truncate(30)
    end
  end
end
