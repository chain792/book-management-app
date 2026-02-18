# typed: strict

module Books
  class GoogleCardComponent < ApplicationComponent
    sig { params(google_book: T::Hash[String, T.untyped]).void }
    def initialize(google_book:)
      @google_book = google_book
    end

    private

    sig { returns(T::Hash[String, T.untyped]) }
    attr_reader :google_book

    sig { returns(String) }
    def title
      volume_info["title"] || "No Title"
    end

    sig { returns(String) }
    def authors
      (volume_info["authors"] || []).join(", ").presence || "Unknown Author"
    end

    sig { returns(String) }
    def published_date
      volume_info["publishedDate"] || ""
    end

    sig { returns(String) }
    def thumbnail_url
      image_links = volume_info["imageLinks"]
      image_links ? (image_links["thumbnail"] || image_links["smallThumbnail"]) : "/sample.png"
    end

    sig { returns(T::Hash[String, T.untyped]) }
    def volume_info
      google_book["volumeInfo"] || {}
    end

    sig { returns(String) }
    def new_book_path_with_params
      helpers.new_book_path(volumeInfo: helpers.set_google_book_params(google_book))
    end
  end
end
