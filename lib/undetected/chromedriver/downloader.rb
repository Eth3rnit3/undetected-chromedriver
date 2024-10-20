# frozen_string_literal: true

require 'net/http'
require 'json'
module Undetected
  module Chromedriver
    class Downloader
      class ChromeDriverNotFoundError < StandardError; end
      class DownloadError < StandardError; end
      class WriteError < StandardError; end

      CHROMEDRIVER_API_URL  = 'https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json'
      PLATFORM_PATH         = %i[channels Stable downloads chromedriver].freeze

      def self.download(version, output_path)
        os        = platform
        url       = "https://storage.googleapis.com/chrome-for-testing-public/#{version}/#{os}/chromedriver-#{os}.zip"
        zip_data  = download_zip(url)

        write_file(zip_data, output_path)
        output_path
      end

      def self.download_zip(url)
        uri = URI(url)
        Net::HTTP.get(uri)
      rescue StandardError => e
        raise DownloadError, "Failed to download chromedriver zip: #{e.message}"
      end

      def self.write_file(data, output_path)
        File.binwrite(output_path, data)
      rescue StandardError => e
        raise WriteError, "Failed to write chromedriver zip: #{e.message}"
      end

      def self.platform
        case RUBY_PLATFORM
        when /darwin/
          mac_os
        when /linux/
          'linux64'
        when /mingw|mswin/
          win
        else
          raise ChromeDriverNotFoundError, 'Unsupported platform'
        end
      end

      def self.mac_os
        case `uname -m`.strip
        when 'arm64'
          'mac-arm64'
        else
          'mac-x64'
        end
      end

      def self.win
        case `wmic os get osarchitecture`.strip
        when '64-bit'
          'win64'
        else
          'win32'
        end
      end

      private_class_method :download_zip, :write_file, :platform, :mac_os, :win
    end
  end
end
