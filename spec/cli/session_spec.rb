require 'spec_helper'

describe Tix::CLI::Session do
  let(:set_1) { double(Tix::RecordSet, name: 'Set 1') }
  let(:set_2) { double(Tix::RecordSet, name: 'Set 2') }
  let(:sets) { [set_1, set_2] }

  subject { described_class.new(sets) }

  describe 'record set caching' do
    it 'caches record sets' do
      expect(subject.record_sets).to eq sets
    end
  end

  describe '#start' do
    let(:response) { 'any key' }

    before do
      allow(subject).to receive(:ask).and_return(response)
      allow(Tix::CLI::Menu).to receive(:new).and_raise(Quit)
      allow(subject).to receive(:exit)
      subject.start
    end

    it 'executes menu' do
      expect(Tix::CLI::Menu).to have_received(:new)
    end

    context 'when asked to quit' do
      let(:response) { 'quit' }

      it 'does not execute menu' do
        expect(Tix::CLI::Menu).not_to have_received(:new)
      end

      it 'exits code zero' do
        expect(subject).to have_received(:exit).with(0)
      end
    end
  end
end
