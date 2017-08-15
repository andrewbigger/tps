require 'spec_helper'

describe Tps::Record do
  let(:string_attribute_value) { 'bar' }
  let(:int_attribute_value)    { 4 }
  let(:bool_attribute_value)   { true }
  let(:array_attribute_value)  { %w[crock glitch] }
  let(:params) do
    {
      str: string_attribute_value,
      arr: array_attribute_value,
      bol: bool_attribute_value,
      int: int_attribute_value
    }
  end

  subject { described_class.new(params) }

  describe '#fields' do
    it 'returns a list of record fields' do
      expect(subject.fields).to eq %i[str arr bol int]
    end
  end

  describe '#get' do
    it 'returns string attribute values' do
      expect(subject.get(:str)).to eq string_attribute_value
    end

    it 'returns array attribute values' do
      expect(subject.get(:arr)).to eq array_attribute_value
    end

    it 'returns integer attribute values' do
      expect(subject.get(:int)).to eq int_attribute_value
    end

    it 'returns boolean attribute values' do
      expect(subject.get(:bol)).to eq bool_attribute_value
    end

    context 'when attribute does not exist' do
      it 'raises attribute not found error' do
        expect { subject.get(:bar) }.to raise_error AttributeNotFound
      end
    end
  end

  describe '#match?' do
    let(:query) { { foo: 'bar', biz: 'baz' } }

    context 'both queries match' do
      before do
        allow(subject).to receive(:compare).and_return(0, 0)
      end

      it 'returns true' do
        expect(subject.match?(query)).to be true
      end
    end

    context 'one query matches' do
      before do
        allow(subject).to receive(:compare).and_return(0, nil)
      end

      it 'returns false' do
        expect(subject.match?(query)).to be false
      end
    end

    context 'no query matches' do
      before do
        allow(subject).to receive(:compare).and_return(nil, nil)
      end

      it 'returns false' do
        expect(subject.match?(query)).to be false
      end
    end
  end

  describe '#compare' do
    let(:attribute) { :id }
    let(:value)     { 'some-id' }

    context 'when comparitor method is present' do
      before do
        allow(subject).to receive(:id_compare) {}
        subject.compare(attribute, value)
      end

      it 'delegates comparison to comparitor method' do
        expect(subject).to have_received(:id_compare).with(attribute, value)
      end
    end

    context 'when comparitor is not present' do
      let(:attribute_retrieval_spy) { double }
      let(:value_spy) { double }

      before do
        allow(attribute_retrieval_spy).to receive(:to_s).and_return(attribute)
        allow(subject).to receive(:get).and_return(attribute_retrieval_spy)
        allow(Regexp).to receive(:new).and_call_original
        allow(value).to receive(:to_s).and_call_original
        subject.compare(attribute, value)
      end

      it 'stringifies attribute' do
        expect(subject).to have_received(:get).with(attribute)
        expect(attribute_retrieval_spy).to have_received(:to_s)
      end

      it 'stringifies value' do
        expect(value).to have_received(:to_s)
      end

      it 'creates regular expression for comparison' do
        expect(Regexp).to have_received(:new).with(value, true)
      end
    end

    context 'commparing strings' do
      let(:attribute) { :foo }
      let(:value)     { 'bar' }

      before { allow(subject).to receive(:get).and_return(value) }

      it 'returns true on full match' do
        expect(subject.compare(attribute, value)).to eq 0
      end

      it 'returns true on partial match' do
        expect(subject.compare(attribute, "ba")).to eq 0
      end

      it 'returns false on no match' do
        expect(subject.compare(attribute, 'bogus')).to be nil
      end
    end
  end
end
