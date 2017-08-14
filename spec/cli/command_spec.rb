require 'spec_helper'

describe Tix::CLI::Command do
  let(:session) { double(Tix::CLI::Session) }
  subject { described_class.new(session) }

  before { allow(subject).to receive(:ask) }

  it 'caches session' do
    expect(subject.instance_variable_get(:@session))
      .to eq session
  end

  describe '#br' do
    before { allow(subject).to receive(:say) }

    it 'outputs line break' do
      subject.br
      expect(subject).to have_received(:say).with("\n")
    end
  end

  describe '#ask_s' do
    let(:prompt) { 'enter something that will be returned as string' }
    let(:response) { 'instruction' }
    let(:quit) { false }

    before do
      allow(subject).to receive(:ask).and_return(response)
      allow(subject).to receive(:quit?).and_return(quit)
    end

    it 'delegates prompting to highline' do
      subject.ask_s(prompt)
      expect(subject).to have_received(:ask).with(prompt)
    end

    it 'returns response' do
      expect(subject.ask_s(prompt)).to eq response
    end

    context 'given quit signal' do
      let(:quit) { true }

      it 'raises quit signal' do
        expect { subject.ask_s(prompt) }.to raise_error Quit
      end
    end
  end

  describe '#ask_int' do
    let(:prompt) { 'enter something that will be turned into int' }
    let(:response) { '4' }

    before do
      allow(subject).to receive(:ask_s).and_return(response)
    end

    it 'delegates prompt to #ask_s' do
      subject.ask_int(prompt)
      expect(subject).to have_received(:ask_s).with(prompt)
    end

    it 'returns int-erized response' do
      expect(subject.ask_int(prompt)).to eq 4
    end
  end

  describe '#ask_sym' do
    let(:prompt) { 'enter something that will be turned into symbol' }
    let(:response) { 'id' }

    before do
      allow(subject).to receive(:ask_s).and_return(response)
    end

    it 'delegates prompt to #ask_s' do
      subject.ask_sym(prompt)
      expect(subject).to have_received(:ask_s).with(prompt)
    end

    it 'returns symbolized response' do
      expect(subject.ask_sym(prompt)).to eq :id
    end

    context 'given integer input' do
      let(:response) { 1 }

      it 'returns symbolized response prefixed with an underscore' do
        expect(subject.ask_sym(prompt)).to eq :_1
      end
    end

    context 'given weird input' do
      let(:response) { 'The rain in Spain falls softly on the plain' }

      it 'returns symbolized response' do
        expect(subject.ask_sym(prompt))
          .to eq :"The rain in Spain falls softly on the plain"
      end
    end
  end

  describe '#number?' do
    context 'given zero' do
      it 'returns true' do
        expect(subject.number?('0')).to be true
      end
    end

    context 'given number greater than zero' do
      it 'returns true' do
        expect(subject.number?('20')).to be true
      end
    end

    context 'given string' do
      it 'returns false' do
        expect(subject.number?('some-string')).to be false
      end
    end
  end

  describe '#quit?' do
    context 'when given quit command' do
      it 'returns true when given \'quit\'' do
        expect(subject.quit?('quit')).to be true
      end

      it 'returns true when given \'      QuIt    \'' do
        expect(subject.quit?('      QuIt    ')).to be true
      end
    end

    context 'when not given quit command' do
      it 'returns false when given another command' do
        expect(subject.quit?('something')).to be false
      end
    end
  end
end
