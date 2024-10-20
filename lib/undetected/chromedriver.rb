# frozen_string_literal: true

require_relative 'chromedriver/version'
require_relative 'chromedriver/downloader'

module Undetected
  module Chromedriver
    DRIVER_PATH = "#{Dir.home}/bin/chromedriver".freeze

    class Error < StandardError; end
    # Your code goes here...
  end
end
