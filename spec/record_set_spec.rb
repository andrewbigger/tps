require 'spec_helper'

describe Tps::RecordSet do
  let(:name)          { 'set name' }
  let(:records_array) { [] }
  let(:record)        { double(Tps::Record) }

  subject { described_class.new(name, records_array) }

  describe '.new_from_array' do
    let(:array) do
      [
        {
          foo: 'bar'
        },
        {
          biz: 'buzz'
        }
      ]
    end

    let(:set) { described_class.new_from_array(name, array) }

    it 'returns a record set' do
      expect(set).to be_a Tps::RecordSet
    end

    it 'has a name' do
      expect(set.name).to eq name
    end

    it 'contains Tps::Records' do
      expect(set.records).to all(be_a(Tps::Record))
    end

    it 'has expected attributes' do
      expect(set.first.get(:foo)).to eq 'bar'
      expect(set.last.get(:biz)).to eq 'buzz'
    end

    it 'caches record fields' do
      expect(set.fields).to eq %i[foo biz]
    end
  end

  describe 'delegation' do
    before do
      allow(records_array).to receive(:<<)
      allow(records_array).to receive(:select)
      allow(records_array).to receive(:each)
    end

    it 'delegates << to records array' do
      subject << record
      expect(records_array).to have_received(:<<).with(record)
    end

    it 'delegates select to records array' do
      subject.select
      expect(records_array).to have_received(:select)
    end

    it 'delegates each to records array' do
      subject.each
      expect(records_array).to have_received(:each)
    end
  end

  describe '#where' do
    let(:records_array) { [record, double(match?: false)] }
    let(:query) { {} }

    before do
      allow(records_array).to receive(:select).and_call_original
      allow(record).to receive(:match?)
      subject.where(query)
    end

    it 'calls select on records array' do
      expect(records_array).to have_received(:select)
    end

    it 'passes query to match method on record' do
      expect(record).to have_received(:match?).with(query)
    end

    it 'returns a record set' do
      expect(subject.where(query)).to be_a Tps::RecordSet
    end
  end
end
