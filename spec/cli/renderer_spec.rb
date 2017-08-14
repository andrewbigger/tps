require 'spec_helper'

describe Tix::CLI::Renderer do
  before do
    allow(Pry::ColorPrinter).to receive(:pp) {}
  end

  subject { Class.new.extend(described_class) }

  describe '#render' do
    before do
      allow(subject).to receive(:render_array) {}
      allow(subject).to receive(:render_hash)  {}
    end

    context 'given an array' do
      let(:array) { [] }

      it 'delegates array rendering to #render_array' do
        subject.render(array)
        expect(subject).to have_received(:render_array).with(array)
      end
    end

    context 'given a hash' do
      let(:hash) { {} }

      it 'delegates rendering to #render_hash' do
        subject.render(hash)
        expect(subject).to have_received(:render_hash).with(hash)
      end
    end
  end

  describe '#render array' do
    let(:array) { %w[array of stuff] }

    it 'delegates rendering to pry pretty print' do
      subject.render_array(array)
      expect(Pry::ColorPrinter).to have_received(:pp).with(array)
    end
  end

  describe '#render_hash' do
    let(:hash) { { hash: 'of', stuff: 'things' } }

    it 'delegates rendering to pry pretty print' do
      subject.render_hash(hash)
      expect(Pry::ColorPrinter).to have_received(:pp).with(hash)
    end
  end
end
