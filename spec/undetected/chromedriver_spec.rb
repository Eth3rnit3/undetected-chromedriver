# frozen_string_literal: true

RSpec.describe Undetected::Chromedriver do
  it "has a version number" do
    expect(Undetected::Chromedriver::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
