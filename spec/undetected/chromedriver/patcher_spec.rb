# frozen_string_literal: true

RSpec.describe Undetected::Chromedriver::Patcher do
  subject(:call) { described_class.new(driver_path).call }

  let(:driver_path) { 'spec/fixtures/chromedriver' }

  before { FileUtils.cp(driver_path, "#{driver_path}.bak") if driver_path && File.exist?(driver_path) }

  after do
    if driver_path && File.exist?("#{driver_path}.bak")
      FileUtils.cp("#{driver_path}.bak", driver_path)
      FileUtils.rm("#{driver_path}.bak")
    end
  end

  describe '#call' do
    context 'when the driver path is nil' do
      let(:driver_path) { nil }

      it 'raises an ArgumentError' do
        expect { call }.to raise_error(ArgumentError, 'Driver path is required')
      end
    end

    context 'when the driver path does not exist' do
      let(:driver_path) { '/path/to/nonexistent/chromedriver' }

      it { expect { call }.to raise_error(ArgumentError, 'Driver path is not a file') }
    end

    context 'when the driver path is valid and the block is found' do
      it { expect { call }.not_to raise_error }
      it { expect { call }.to output(/ChromeDriver binary patched/).to_stdout }
    end

    context 'when the driver path is valid and the block is not found' do
      let(:driver_path) { 'spec/fixtures/chromedriver_no_injection' }

      it { expect { call }.not_to raise_error }
      it { expect { call }.to output(/No matching code block found/).to_stdout }
    end
  end
end
