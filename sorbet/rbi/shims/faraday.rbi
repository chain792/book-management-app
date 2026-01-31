# typed: true

module Faraday
  class << self
    def get(url = nil, params = nil, headers = nil); end
    def post(url = nil, body = nil, headers = nil); end
    def put(url = nil, body = nil, headers = nil); end
    def patch(url = nil, body = nil, headers = nil); end
    def delete(url = nil, params = nil, headers = nil); end
    def head(url = nil, params = nil, headers = nil); end
  end
end
