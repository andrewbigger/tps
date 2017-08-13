require 'spec_helper'

describe Tix::CLI::Search do
  let(:set_1) { double(Tix::RecordSet, name: 'Set 1') }
  let(:set_2) { double(Tix::RecordSet, name: 'Set 2') }
  let(:session) { Tix::CLI::Session.new([set_1, set_2]) }

  subject { described_class.new(session) }

  describe '#execute' do
    before do
      allow(subject).to receive(:select_record_set)
      allow(subject).to receive(:select_term)
      allow(subject).to receive(:select_value)
      allow(subject).to receive(:print_results)
      subject.execute
    end

    it 'prompts user for record set selection' do
      expect(subject).to have_received(:select_record_set)
    end

    it 'prompts user for search term' do
      expect(subject).to have_received(:select_term)
    end

    it 'prompts user for search value' do
      expect(subject).to have_received(:select_value)
    end

    it 'prints results' do
      expect(subject).to have_received(:print_results)
    end

    context 'given an invalid choice is made' do
      before do
        allow(subject).to receive(:say)
        allow(subject).to receive(:select_record_set)
          .and_raise(InvalidChoice)
      end

      it 'notifies user that unknown attribute or option detected' do
        subject.execute
        expect(subject).to have_received(:say)
          .with('Unknown attribute or option')
      end
    end
  end

  describe '#choices' do
    it 'returns a list of options' do
      expect(subject.choices).to eq '1) Set 1, 2) Set 2'
    end
  end

  describe '#select_record_set' do
    let(:choice_prompt) { "the record set please" }
    let(:choice) { '2' }

    before do
      allow(subject).to receive(:choices).and_return(choice_prompt)
      allow(subject).to receive(:ask).and_return(choice)
    end

    it 'asks for record set choice' do
      subject.select_record_set
      expect(subject).to have_received(:ask)
        .with("Select #{choice_prompt}")
    end

    it 'sets the record set' do
      subject.select_record_set
      expect(subject.instance_variable_get(:@record_set))
        .to eq set_2
    end

    context 'given an unknown choice' do
      let(:choice) { 'Bogus' }

      it 'raises invalid choice error' do
        expect { subject.select_record_set }
          .to raise_error InvalidChoice
      end
    end
  end

  describe '#select_value' do
    let(:search_term) { 'value' }

    before do
      allow(subject).to receive(:ask).and_return(search_term)
      subject.select_value  
    end
    
    it 'asks for search term' do
      expect(subject).to have_received(:ask)
        .with('Enter search value')
    end

    it 'assigns given search term to @value' do
      expect(subject.instance_variable_get(:@value))
        .to eq search_term
    end
  end

  describe '#print_results' do
    let(:record_set) { set_1 }
    let(:result_record) { double(data: 'something') }
    let(:result) { [result_record, result_record] }

    before do
      subject.instance_variable_set(:@record_set, record_set)
      allow(record_set).to receive(:where).and_return(result)
      allow(subject).to receive(:render) {}
      subject.print_results
    end

    it 'renders each result data' do
      expect(subject).to have_received(:render)
        .with(result_record.data).twice
    end

    context 'given no results found' do
      let(:result) { [] }

      before { allow(subject).to receive(:say) }

      it 'renders no results found message' do
        subject.print_results
        expect(subject).to have_received(:say).with('No results found')
      end
    end
  end
end
