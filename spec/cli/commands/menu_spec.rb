require 'spec_helper'

describe Tix::CLI::Menu do
  let(:set_1) { double(Tix::RecordSet, name: 'Set 1') }
  let(:set_2) { double(Tix::RecordSet, name: 'Set 2') }
  let(:session) { Tix::CLI::Session.new([set_1, set_2]) }

  before do
  end

  subject { described_class.new(session) }

  describe '#execute' do
    before do
      allow(subject).to receive(:print_options) {}
      allow(subject).to receive(:select_option) {}
      subject.execute
    end

    it 'prints available options' do
      expect(subject).to have_received(:print_options)
    end

    it 'chooses selected option' do
      expect(subject).to have_received(:select_option)
    end
  end

  describe '#print_options' do
    before do
      allow(subject).to receive(:say)
      allow(subject).to receive(:br)
      subject.print_options
    end

    it 'prints search options prompt' do
      expect(subject).to have_received(:say).with('Select search options:')
    end

    it 'prints search option' do
      expect(subject).to have_received(:say)
        .with('* Press 1 to search Zendesk')
    end

    it 'prints searchable fields option' do
      expect(subject).to have_received(:say)
        .with('* Press 2 to view a list of searchable fields')
    end

    it 'prints quit option' do
      expect(subject).to have_received(:say)
        .with('* Type \'quit\' to exit')
    end

    it 'adds line break after prompt' do
      expect(subject).to have_received(:br)
    end
  end

  describe '#select_option' do
    let(:choice) { :unknown }
    let(:command) { double(Tix::CLI::Command) }

    before do
      allow(subject).to receive(:ask_sym).and_return(choice)
      allow(Tix::CLI::Search).to receive(:new).and_return(command)
      allow(Tix::CLI::List).to receive(:new).and_return(command)
      allow(command).to receive(:execute)
    end

    context 'when search option is selected' do
      let(:choice) { :_1 }
      before { subject.select_option }

      it 'creates search command' do
        expect(Tix::CLI::Search).to have_received(:new)
      end

      it 'executes search command' do
        expect(command).to have_received(:execute)
      end
    end

    context 'when list option is selected' do
      let(:choice) { :_2 }
      before { subject.select_option }

      it 'creates list command' do
        expect(Tix::CLI::List).to have_received(:new)
      end

      it 'executes command' do
        expect(command).to have_received(:execute)
      end
    end

    context 'when quit option is selected' do
      let(:choice) { :quit }

      it 'raises quit signal' do
        expect { subject.select_option }.to raise_error Quit
      end
    end

    context 'when unknown option is selected' do
      let(:choice) { :bogus }

      before do
        allow(subject).to receive(:select_option)
        subject.select_option
      end

      it 'executes select option again' do
        expect(subject).to have_received(:select_option)
      end
    end
  end
end
