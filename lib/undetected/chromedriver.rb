# frozen_string_literal: true

require 'active_support'
require_relative 'chromedriver/version'
require_relative 'chromedriver/downloader'
require_relative 'chromedriver/extractor'
require_relative 'chromedriver/patcher'

module Undetected
  module Chromedriver
    DRIVER_PATH     = "#{Dir.home}/bin/chromedriver".freeze
    DOWNLOAD_PATH   = '/tmp/chromedriver.zip'
    USER_DATA_DIR   = "#{Dir.home}/.config/undetected-chromedriver".freeze
    USER_PROFILE    = 'Default'

    class Error < StandardError; end

    class << self
      include ActiveSupport::Configurable

      configure do |config|
        config.download_path      = DOWNLOAD_PATH
        config.chromedriver_path  = DRIVER_PATH
        config.user_data_dir      = USER_DATA_DIR
        config.user_profile       = USER_PROFILE
      end

      def initialize(options = nil)
        @options = options || default_options
      end

      private

      def default_options
        options = Selenium::WebDriver::Chrome::Options.new
        options.exclude_switches = ['enable-automation']
        options.add_argument("--user-data-dir=#{config.user_data_dir}")
        options.add_argument("--profile-directory=#{config.user_profile}")

        options.add_argument('--start-maximized')
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_argument('--disable-popup-blocking')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-software-rasterizer')
        options.add_argument('--disable-features=VizDisplayCompositor')
        options.add_argument('--disable-features=IsolateOrigins,site-per-process')
        options.add_argument('--disable-features=site-per-process')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingIfIsolating')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingAlways')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingIfIsolating')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingAlways')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingIfIsolating')
        options.add_argument('--disable-features=CrossSiteDocumentBlockingAlways')

        options
      end

      def agents
        [
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
          'Mozilla/5.0 (iPad; CPU OS 13_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Mobile/15E148 Safari/604.1',
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Mobile Safari/537.36'
        ]
      end
    end
  end
end
