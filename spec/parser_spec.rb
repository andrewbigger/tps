require 'spec_helper'

describe Tix::Parser do
  describe '.parse' do
    let(:file)   { double(File) }
    let(:parser) { double(Yajl::Parser) }

    before do
      allow(Tix::Parser).to receive(:parser).and_return(parser)
      allow(parser).to receive(:parse)
      described_class.parse(file)
    end

    it 'parses given file' do
      expect(parser).to have_received(:parse).with(file)
    end
  end

  describe '.parser' do
    before { allow(Yajl::Parser).to receive(:new).and_call_original }
    it 'returns yajl parser' do
      expect(described_class.parser).to be_a Yajl::Parser
    end

    it 'configures parser to symbolize keys' do
      described_class.parser
      expect(Yajl::Parser).to have_received(:new).with(symbolize_keys: true)
    end
  end
end