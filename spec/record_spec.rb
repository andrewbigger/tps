require 'spec_helper'

describe Tix::Record do
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
    shared_examples 'an exact match when given' do |value|
      let(:params) { { attr: value, another_attr: 'something else' } }
      let(:query)  { { attr: value } }

      it 'returns true when there is an exact match' do
        expect(subject.match?(query)).to be true
      end
    end

    shared_examples 'a partial match when given' do |value|
      let(:params) { { attr: "#{value} with stuff", another_attr: 5 } }
      let(:query)  { { attr: value } }

      it 'returns true when there is a partial match' do
        expect(subject.match?(query)).to be true
      end
    end

    shared_examples 'no match when given' do |value|
      let(:params) { { attr: 'some record content'.gsub!(value) } }
      let(:query)  { { attr: value } }

      it 'returns false when there is no match' do
        expect(subject.match?(query)).to be false
      end
    end

    context 'when matching a string value' do
      it_behaves_like 'an exact match when given', 'a string'
      it_behaves_like 'a partial match when given', 'some string'
      it_behaves_like 'no match when given', 'another string'
    end

    context 'when matching an integer value' do
      it_behaves_like 'an exact match when given', 4
      it_behaves_like 'a partial match when given', 6
      it_behaves_like 'no match when given', 10
    end

    context 'when matching a boolean value' do
      it_behaves_like 'an exact match when given', true
      it_behaves_like 'a partial match when given', false
      it_behaves_like 'no match when given', true
    end
  end
end
