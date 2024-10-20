# frozen_string_literal: true

require 'zip'

module Undetected
  module Chromedriver
    class Extractor
      def initialize(zip_path, driver_path)
        @zip_path       = zip_path
        @driver_path    = driver_path
        @driver_folder  = File.dirname(driver_path)
      end

      def call
        File.delete(@driver_path) if File.exist?(@driver_path)
        extract
      end

      private

      def extract
        Zip::File.open(@zip_path) do |zip_file|
          zip_file.each do |f|
            FileUtils.mkdir_p(@driver_folder) unless File.directory?(@driver_folder)

            zip_file.extract(f, @driver_path) if File.basename(f.name) == 'chromedriver'
          end
        end
      end
    end
  end
end
