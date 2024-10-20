# frozen_string_literal: true

RSpec.describe Undetected::Chromedriver::Downloader do
  subject { described_class }

  describe '#download' do
    let(:platform) { 'linux64' }
    let(:mac_arm_binary) { 'chromedriver-mac-arm64' }
    let(:mac_intel_binary) { 'chromedriver-mac-x64' }
    let(:linux64_binary) { 'chromedriver-linux-x64' }
    let(:win32_binary) { 'chromedriver-win32' }
    let(:win64_binary) { 'chromedriver-win64' }

    before do
      stub_request(:get, described_class::CHROMEDRIVER_API_URL).to_return(body: load_fixture('chromedriver.json'))
      stub_request(:get, %r{mac-x64/chromedriver-mac-x64.zip}).to_return(body: mac_intel_binary)
      stub_request(:get, %r{mac-arm64/chromedriver-mac-arm64.zip}).to_return(body: mac_arm_binary)
      stub_request(:get, %r{linux64/chromedriver-linux64.zip}).to_return(body: linux64_binary)
      stub_request(:get, %r{win32/chromedriver-win32.zip}).to_return(body: win32_binary)
      stub_request(:get, %r{win64/chromedriver-win64.zip}).to_return(body: win64_binary)
      allow(subject).to receive(:platform).and_return(platform)
      allow(File).to receive(:binwrite).and_return(true)
    end

    after { File.delete('/tmp/chromedriver.zip') if File.exist?('/tmp/chromedriver.zip') }

    context 'when platform is mac arm' do
      let(:platform) { 'mac-arm64' }

      it 'downloads chromedriver' do
        expect(subject.download).to eq('/tmp/chromedriver.zip')
        expect(a_request(:get, %r{mac-arm64/chromedriver-mac-arm64.zip})).to have_been_made
        expect(File).to have_received(:binwrite).with('/tmp/chromedriver.zip', mac_arm_binary)
      end
    end

    context 'when platform is mac intel' do
      let(:platform) { 'mac-x64' }

      it 'downloads chromedriver' do
        expect(subject.download).to eq('/tmp/chromedriver.zip')
        expect(a_request(:get, %r{mac-x64/chromedriver-mac-x64.zip})).to have_been_made
        expect(File).to have_received(:binwrite).with('/tmp/chromedriver.zip', mac_intel_binary)
      end
    end

    context 'when platform is linux' do
      let(:platform) { 'linux64' }

      it 'downloads chromedriver' do
        expect(subject.download).to eq('/tmp/chromedriver.zip')
        expect(a_request(:get, %r{linux64/chromedriver-linux64.zip})).to have_been_made
        expect(File).to have_received(:binwrite).with('/tmp/chromedriver.zip', linux64_binary)
      end
    end

    context 'when platform is windows 32 bit' do
      let(:platform) { 'win32' }

      it 'downloads chromedriver' do
        expect(subject.download).to eq('/tmp/chromedriver.zip')
        expect(a_request(:get, %r{win32/chromedriver-win32.zip})).to have_been_made
        expect(File).to have_received(:binwrite).with('/tmp/chromedriver.zip', win32_binary)
      end
    end

    context 'when platform is windows 64 bit' do
      let(:platform) { 'win64' }

      it 'downloads chromedriver' do
        expect(subject.download).to eq('/tmp/chromedriver.zip')
        expect(a_request(:get, %r{win64/chromedriver-win64.zip})).to have_been_made
        expect(File).to have_received(:binwrite).with('/tmp/chromedriver.zip', win64_binary)
      end
    end

    context 'when platform is unknown' do
      let(:platform) { 'unknown' }

      it 'raises an error' do
        expect { subject.download }.to raise_error(described_class::ChromeDriverNotFoundError)
      end
    end

    context 'when chromedriver json is invalid' do
      before { stub_request(:get, described_class::CHROMEDRIVER_API_URL).to_return(body: 'invalid json') }

      it 'raises an error' do
        expect { subject.download }.to raise_error(described_class::DownloadError)
      end
    end

    context 'when chromedriver json is not found' do
      before { stub_request(:get, described_class::CHROMEDRIVER_API_URL).to_return(status: 404) }

      it 'raises an error' do
        expect { subject.download }.to raise_error(described_class::DownloadError)
      end
    end

    context 'when writing the file fails' do
      before { allow(File).to receive(:binwrite).and_raise(StandardError) }

      it 'raises an error' do
        expect { subject.download }.to raise_error(described_class::WriteError)
      end
    end
  end
end
