# typed: true

class Shrine
  class Attachment < ::Module
    def remote_url=(url); end
    def remote_url; end
  end
end

class User
  def remote_avatar_url=(url); end
  def remote_avatar_url; end
end

class Book
  def remote_book_image_url=(url); end
  def remote_book_image_url; end
end
