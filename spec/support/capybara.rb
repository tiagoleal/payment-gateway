require "capybara/rspec"
require "selenium/webdriver"

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :selenium_remote do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,900')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_REMOTE_URL", "http://selenium:4444/wd/hub"),
    options: options
  )
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_remote

# Configurações adicionais para ambiente Docker
if ENV['SELENIUM_REMOTE_URL']
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3000
  Capybara.app_host = "http://#{ENV.fetch('APP_HOST', 'web')}:3000"
end
