# frozen_string_literal: true

require 'selenium-webdriver'
require_relative 'chromedriver/version'
require_relative 'chromedriver/downloader'
require_relative 'chromedriver/extractor'
require_relative 'chromedriver/patcher'
require_relative 'chromedriver/configuration'

module Undetected
  module Chromedriver
    class Error < StandardError; end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def config
        configuration.config
      end

      def configure
        yield(configuration)
      end

      def patch!
        Downloader.download(config.download_path)
        Extractor.new(config.download_path, config.chromedriver_path).call
        Patcher.new(config.chromedriver_path).call
      end

      def patched?
        Patcher.new(config.chromedriver_path).patched?
      end

      def driver(options = nil)
        options ||= config.options
        Selenium::WebDriver.for :chrome, options: options
      end
    end
  end
end
