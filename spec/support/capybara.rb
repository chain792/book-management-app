REMOTE_SELENIUM_URL = ENV.fetch('SELENIUM_REMOTE_URL', 'http://selenium_chrome:4444/wd/hub').freeze

def remote_selenium?
  return true if ENV['USE_REMOTE_SELENIUM'] == '1'
  return true if File.exist?('/.dockerenv')
  false
end

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    if example.metadata[:js]
      if remote_selenium?
        driven_by :remote_chrome
        Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
        Capybara.server_port = 4444
        Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
      else
        driven_by :selenium_chrome_headless
      end
    else
      driven_by :rack_test
    end
  end
end

# Chrome
Capybara.register_driver :remote_chrome do |app|
  url = REMOTE_SELENIUM_URL
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')

  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, options: options)
end
