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
        allow(subject).to receive(:compare).and_return(true, true)
      end

      it 'returns true' do
        expect(subject.match?(query)).to be true
      end
    end

    context 'one query matches' do
      before do
        allow(subject).to receive(:compare).and_return(true, false)
      end

      it 'returns false' do
        expect(subject.match?(query)).to be false
      end
    end

    context 'no query matches' do
      before do
        allow(subject).to receive(:compare).and_return(false, false)
      end

      it 'returns false' do
        expect(subject.match?(query)).to be false
      end
    end
  end

  describe '#compare' do
    let(:attribute) { :id }
    let(:value)     { 'some-id' }
    let(:params) { { attribute => value } }

    context 'when searching for \empty' do
      let(:value) { '' }
      let(:params) { { attribute => '' } }

      before do
        allow(subject).to receive(:id_comparitor)
        allow(subject).to receive(:val_empty?)
        allow(subject).to receive(:string_match?)
        subject.compare(attribute, '\empty')
      end

      it 'delegates comparison to empty comparitor' do
        expect(subject).to have_received(:val_empty?).with(value)
      end

      it 'does not run attribute comparitor' do
        expect(subject).not_to have_received(:id_comparitor)
      end

      it 'does not run default comparitor' do
        expect(subject).not_to have_received(:string_match?)
      end
    end

    context 'when comparitor method is present' do
      before do
        allow(subject).to receive(:id_compare) {}
        subject.compare(attribute, value)
      end

      it 'delegates comparison to comparitor method' do
        expect(subject).to have_received(:id_compare).with(value)
      end
    end

    context 'when comparitor is not present' do
      before do
        allow(subject).to receive(:string_match?)
        allow(subject).to receive(:get).with(attribute).and_return(value)
        subject.compare(attribute, value)
      end

      it 'delegates comparison to #string_match? comparitor by default' do
        expect(subject).to have_received(:string_match?).with(value, value)
      end
    end
  end
end
