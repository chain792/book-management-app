require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  # Google API Key をカセットから隠す
  config.filter_sensitive_data('<GOOGLE_API_KEY>') { ENV['GOOGLE_API_KEY'] }

  # Selenium/Chrome などの内部通信を許可
  config.ignore_localhost = true
  config.ignore_hosts 'selenium_chrome'
  config.ignore_request do |request|
    URI(request.uri).host == IPSocket.getaddress(Socket.gethostname)
  end
end
