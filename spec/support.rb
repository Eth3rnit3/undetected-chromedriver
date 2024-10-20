# frozen_string_literal: true

module Support
  def load_fixture(file)
    File.read(File.expand_path("fixtures/#{file}", __dir__))
  end
end
