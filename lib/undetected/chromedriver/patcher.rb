# frozen_string_literal: true

module Undetected
  module Chromedriver
    class Patcher
      def initialize(driver_path)
        @driver_path  = driver_path
        @js_injection = '{console.log("long live king ruby<3")}'
      end

      def call
        validate!
        patch
      end

      private

      def validate!
        raise ArgumentError, 'Driver path is required' if @driver_path.nil?
        raise ArgumentError, 'Driver path is not a file' unless File.file?(@driver_path)

        true
      end

      def patch
        puts('Patching ChromeDriver binary...')
        start_time  = Time.now
        data        = File.binread(@driver_path)
        inj_block   = data.match(/\{window\.cdc.*?;\}/m)

        if inj_block
          target_bytes      = inj_block[0]
          new_target_bytes  = @js_injection.ljust(
            target_bytes.length, ' '
          )
          patched_data = data.gsub(target_bytes, new_target_bytes)

          # Check if content changed before writing to file
          if patched_data == data
            puts('ChromeDriver binary already patched.')
          else
            puts("Found block:\n#{target_bytes}\nReplacing with:\n#{new_target_bytes}")
            # Write patched data back to file
            File.binwrite(@driver_path, patched_data)
            FileUtils.chmod(0o755, @driver_path)
            elapsed_time = Time.now - start_time
            puts("ChromeDriver binary patched! Patching took us #{elapsed_time.round(2)} seconds.")
          end
        else
          puts('No matching code block found.')
          false
        end
      end
    end
  end
end
