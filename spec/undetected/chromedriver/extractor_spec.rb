# frozen_string_literal: true

RSpec.describe Undetected::Chromedriver::Extractor do
  subject(:call) { described_class.new(zip_path, driver_path).call }

  let(:zip_path) { 'spec/fixtures/chromedriver.zip' }
  let(:driver_path) { '/tmp/chromedriver' }

  after { File.delete(driver_path) if File.exist?(driver_path) }

  describe '#call' do
    context 'when extracting chromedriver' do
      before { call }

      it 'extracts chromedriver' do
        expect(File.exist?(driver_path)).to be true
      end

      it 'extracts chromedriver binary' do
        expect(File.size(driver_path)).to be > 0
      end

      it 'extracts chromedriver with correct permissions' do
        expect(File.stat(driver_path).mode.to_s(8)).to eq('100644')
      end

      it 'extracts chromedriver with correct owner' do
        expect(File.stat(driver_path).uid).to eq(Process.uid)
      end

      it 'does not extract other files' do
        expect(Dir.entries(File.dirname(driver_path))).not_to include('Readme.md')
      end
    end

    context 'when extracting chromedriver with existing driver' do
      before do
        FileUtils.touch(driver_path)
        call
      end

      it 'extracts chromedriver' do
        expect(File.exist?(driver_path)).to be true
      end

      it 'extracts chromedriver binary' do
        expect(File.size(driver_path)).to be > 0
      end

      it 'extracts chromedriver with correct permissions' do
        expect(File.stat(driver_path).mode.to_s(8)).to eq('100644')
      end

      it 'extracts chromedriver with correct owner' do
        expect(File.stat(driver_path).uid).to eq(Process.uid)
      end

      it 'does not extract other files' do
        expect(Dir.entries(File.dirname(driver_path))).not_to include('Readme.md')
      end
    end
  end
end
