require 'spec_helper'

describe Tix::CLI do
  describe '.verify_files' do
    let(:name)     { 'file.json' }
    let(:is_file)  { true }
    let(:exist)    { true }
    let(:readable) { true }
    let(:file)     { double(File) }

    before do
      allow(file).to receive(:is_a?).with(File).and_return(is_file)
      allow(File).to receive(:baseanme).with(file).and_return(name)
      allow(File).to receive(:exist?).and_return(exist)
      allow(File).to receive(:readable?).and_return(readable)
    end

    it 'does not raise error' do
      expect { described_class.verify_files(file) }.not_to raise_error
    end

    it 'can process multiple files' do
      described_class.verify_files(file, file)
      expect(file).to have_received(:is_a?).twice
    end

    context 'not given file' do
      let(:is_file) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(file) }
          .to raise_error FileNotFound
      end
    end

    context 'file not found' do
      let(:exist) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(file) }
          .to raise_error FileNotFound
      end
    end

    context 'file not accessible' do
      let(:readable) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(file) }
          .to raise_error FileNotReadable
      end
    end
  end

  describe '.load_record_sets' do
    let(:file) { double(File) }
    let(:parsed_content) do
      [
        {
          foo: 'bar'
        }
      ]
    end

    before do
      allow(File).to receive(:basename)
        .with(file)
        .and_return('File Basename')
      allow(Tix::Parser).to receive(:parse).and_return(parsed_content)
    end

    it 'loads and returns a collection of RecordSet' do
      expect(described_class.load_record_sets(file, file))
        .to all(be_a(Tix::RecordSet))
    end
  end
end
