require 'spec_helper'

describe Tps::CLI::List do
  let(:set_1) { double(Tps::RecordSet, name: 'Set 1') }
  let(:set_2) { double(Tps::RecordSet, name: 'Set 2') }
  let(:session) { Tps::CLI::Session.new([set_1, set_2]) }
  let(:fields) { %i[field_1 field_2] }

  before do
    allow(set_1).to receive(:fields).and_return(fields)
    allow(set_2).to receive(:fields).and_return(fields)
    allow(subject).to receive(:render)
  end

  subject { described_class.new(session) }

  describe '#execute' do
    before { allow(subject).to receive(:print_fields) }

    it 'prints fields for each record set' do
      subject.execute
      expect(subject).to have_received(:print_fields).with(set_1)
      expect(subject).to have_received(:print_fields).with(set_2)
    end
  end

  describe '#print_fields' do
    before do
      allow(subject).to receive(:say)
      allow(subject).to receive(:br)
      subject.print_fields(set_1)
    end

    it 'prints header' do
      expect(subject).to have_received(:say)
        .with('-----------------------------')
    end

    it 'prints search string' do
      expect(subject).to have_received(:say)
        .with('Search Set 1 with')
    end

    it 'renders fields' do
      expect(subject).to have_received(:render).with(fields)
    end

    it 'adds line break after results' do
      expect(subject).to have_received(:br)
    end
  end
end
