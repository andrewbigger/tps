require 'spec_helper'

describe Tps::Comparitors do

  subject { Object.new.extend(described_class) }

  describe '#array_include?' do
    let(:record_val) { ['foo', 'bar', 'baz'] }

    it 'returns true if array contains search value' do
      expect(subject.array_include?(record_val, 'foo')).to be true
    end

    it 'returns false if array does not include full search value' do
      expect(subject.array_include?(record_val, 'bogus')).to be false
    end
  end

  describe '#string_equal?' do
    let(:record_val) { 'foo' }
    
    it 'returns true on match' do
      expect(subject.string_equal?(record_val, record_val)).to be true  
    end

    it 'returns false on partial match' do
      expect(subject.string_equal?(record_val, 'fo')).to be false
    end

    it 'returns false on no match' do
      expect(subject.string_equal?(record_val, 'bar')).to be false
    end
  end

  describe '#string_match?' do
    let(:record_val) { 'foo' }
    let(:search_val) { 'bar' }

    before do
      allow(record_val).to receive(:to_s).and_call_original
      allow(search_val).to receive(:to_s).and_call_original
      allow(Regexp).to receive(:new).and_call_original
    end

    describe 'normalizing params' do
      before { subject.string_match?(record_val, search_val) }

      it 'stringifies record value' do
        expect(record_val).to have_received(:to_s)
      end

      it 'stringifies search value' do
        expect(search_val).to have_received(:to_s)
      end

      it 'creates search match regex' do
        expect(Regexp).to have_received(:new).with(search_val, true)
      end
    end

    describe 'commparing strings' do
      it 'returns true on full match' do
        expect(subject.string_match?(record_val, record_val))
          .to be true
      end

      it 'returns true on partial match' do
        expect(subject.string_match?(record_val, 'fo'))
          .to be true
      end

      it 'is not case sensitive' do
        expect(subject.string_match?(record_val, 'FoO'))
          .to be true
      end

      it 'returns false on no match' do
        expect(subject.string_match?(record_val, 'bogus'))
          .to be false
      end
    end
  end
end
