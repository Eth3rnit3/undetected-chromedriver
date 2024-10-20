# frozen_string_literal: true

require 'active_support'
require 'selenium-webdriver'
module Undetected
  module Chromedriver
    DRIVER_PATH     = "#{Dir.home}/bin/chromedriver".freeze
    DOWNLOAD_PATH   = '/tmp/chromedriver.zip'
    USER_DATA_DIR   = "#{Dir.home}/.config/undetected-chromedriver".freeze
    USER_PROFILE    = 'Default'
    CHROME_VERSION  = '129.0.6668.101'
    AGENTS          = [
      [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
        { width: 1920, height: 1080 }
      ],
      [
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15',
        { width: 1440, height: 900 }
      ],
      [
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        { width: 375, height: 667 }
      ]
    ].freeze

    class Configuration
      include ActiveSupport::Configurable

      configure do |config|
        config.download_path      = DOWNLOAD_PATH
        config.chromedriver_path  = DRIVER_PATH
        config.user_data_dir      = USER_DATA_DIR
        config.user_profile       = USER_PROFILE
        config.chrome_version     = CHROME_VERSION
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("--user-data-dir=#{config.user_data_dir}")
        options.add_argument("--profile-directory=#{config.user_profile}")

        if Gem::Version.new(config.chrome_version) >= Gem::Version.new('100')
          options.add_argument('--headless=new')
        else
          options.add_argument('--headless=chrome')
        end

        agent, size = AGENTS.sample
        options.add_argument("--user-agent=#{agent}")
        options.add_argument("--window-size=#{size[:width]},#{size[:height]}")
        options.add_argument('--start-maximized')
        options.add_argument('--no-sandbox')
        options.add_argument('--lang=fr-FR')

        config.options = options
      end
    end
  end
end
