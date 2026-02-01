# typed: strict

module ApplicationHelper
  extend T::Sig

  sig { params(title: String).returns(String) }
  def page_title(title = "")
    base_title = "EngineerBook"
    title.present? ? "#{title} - #{base_title}" :  base_title
  end

  sig { params(datetime: ActiveSupport::TimeWithZone).returns(String) }
  def date(datetime)
    datetime.strftime("%Y年%m月%d日")
  end

  sig { params(date: ActiveSupport::TimeWithZone).returns(String) }
  def date_ago(date)
    seconds = (Time.zone.now - date).floor

    years = (seconds / (60 * 60 * 24 * 365)).to_i
    return "#{years}年前" if years.positive?

    days = (seconds / (60 * 60 * 24)).to_i
    return "#{days}日前" if days.positive?

    hours = (seconds / (60 * 60)).to_i
    return "#{hours}時間前" if hours.positive?

    minutes = (seconds / 60).to_i
    return "#{minutes}分前" if minutes.positive?

    "#{seconds}秒前"
  end

  sig { params(google_book: T::Hash[String, T.untyped]).returns(String) }
  def google_book_thumbnail(google_book)
    google_book["volumeInfo"]["imageLinks"].nil? ? "sample.png" : google_book["volumeInfo"]["imageLinks"]["thumbnail"]
  end

  sig { params(google_book: T::Hash[String, T.untyped]).returns(T::Hash[String, T.untyped]) }
  def set_google_book_params(google_book)
    google_book["volumeInfo"]["bookImage"] = google_book.dig("volumeInfo", "imageLinks", "thumbnail")
    google_book["volumeInfo"].slice("title", "authors", "publishedDate", "infoLink", "bookImage")
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def default_meta_tags
    {
      site: "EngineerBook",
      charset: "utf-8",
      description: "EngineerBookはITエンジニアのためのITエンジニア本のレビューアプリです。名著と出会うことでエンジニアとして爆速に成長しよう！",
      keywords: "EngineerBook,エンジニアブック,ITエンジニア本",
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url("favicon.png") },
        { href: image_url("favicon.png"), rel: "apple-touch-icon", sizes: "180x180", type: "image/png" }
      ],
      og: {
        title: :site,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("favicon.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image"
      }
    }
  end
end
