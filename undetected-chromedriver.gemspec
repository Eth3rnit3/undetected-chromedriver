# frozen_string_literal: true

require_relative "lib/undetected/chromedriver/version"

Gem::Specification.new do |spec|
  spec.name = "undetected-chromedriver"
  spec.version = Undetected::Chromedriver::VERSION
  spec.authors = ["Eth3rnit3"]
  spec.email = ["eth3rnit3@gmail.com"]

  spec.summary = [
    "Undetected Chromedriver is a Ruby gem that allows you to use the Chrome browser",
    "with Selenium without being detected by anti-bot services."
  ].join(" ")
  spec.description = [
    "Undetected Chromedriver is a Ruby gem that allows you to use the Chrome browser",
    "with Selenium without being detected by anti-bot services.",
    "",
    "This gem is a wrapper around the `selenium-webdriver` gem that provides a way to",
    "use the Chrome browser with Selenium without being detected by anti-bot services.",
    "",
    "It uses the `webdrivers` gem to download the latest version of the Chrome browser",
    "and the Chromedriver binary, and it uses the `selenium-webdriver` gem to interact",
    "with the Chrome browser using the Chromedriver binary."
  ].join("\n")
  spec.homepage = "https://github.com/Eth3rnit3/undetected-chromedriver"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Eth3rnit3/undetected-chromedriver"
  spec.metadata["changelog_uri"] = "https://github.com/Eth3rnit3/undetected-chromedriver/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
