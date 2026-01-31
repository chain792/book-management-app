# typed: true

module ApplicationHelper
  sig { returns(ActionDispatch::Request) }
  def request; end

  sig { params(source: String, options: T.untyped).returns(String) }
  def image_url(source, options = {}); end
end
