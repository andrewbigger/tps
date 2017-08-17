require 'spec_helper'

describe Tps::CLI do
  describe '.verify_files' do
    let(:name)        { 'file.json' }
    let(:is_file)     { true }
    let(:exist)       { true }
    let(:readable)    { true }
    let(:file)        { instance_double(File) }
    let(:input_files) { { orgs: file, users: file, tickets: file } }

    before do
      allow(file).to receive(:is_a?).with(File).and_return(is_file)
      allow(File).to receive(:basename).with(file).and_return(name)
      allow(File).to receive(:exist?).and_return(exist)
      allow(File).to receive(:readable?).and_return(readable)
    end

    it 'does not raise error' do
      expect { described_class.verify_files(input_files) }.not_to raise_error
    end

    it 'can process multiple files' do
      described_class.verify_files(input_files)
      expect(file).to have_received(:is_a?).thrice
    end

    context 'not given file' do
      let(:is_file) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(input_files) }
          .to raise_error FileNotFound
      end
    end

    context 'file not found' do
      let(:exist) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(input_files) }
          .to raise_error FileNotFound
      end
    end

    context 'file not accessible' do
      let(:readable) { false }

      it 'raises FileNotFound error' do
        expect { described_class.verify_files(input_files) }
          .to raise_error FileNotReadable
      end
    end
  end

  describe '.load_record_sets' do
    let(:file)        { instance_double(File) }
    let(:input_files) { { orgs: file, users: file, tickets: file } }
    let(:parsed_content) do
      [
        {
          foo: 'bar'
        }
      ]
    end

    before do
      allow(File).to receive(:basename)
        .with(file)
        .and_return('File Basename')
      allow(Tps::Parser).to receive(:parse).and_return(parsed_content)
    end

    it 'loads and returns a collection of RecordSet' do
      expect(described_class.load_record_sets(input_files))
        .to all(be_a(Tps::RecordSet))
    end

    let(:result)      { described_class.load_record_sets(input_files) }
    let(:orgs_set)    { result[0].records }
    let(:users_set)   { result[1].records }
    let(:tickets_set) { result[2].records }

    it 'parses orgs file into OrganizationRecords' do
      expect(orgs_set).to all(be_a(Tps::OrganizationRecord))
    end

    it 'parses users file into UserRecords' do
      expect(users_set).to all(be_a(Tps::UserRecord))
    end

    it 'parses tickets file into TicketRecords' do
      expect(tickets_set).to all(be_a(Tps::TicketRecord))
    end
  end

  describe '.get_record_config' do
    let(:type) { :orgs }
    let(:file) { instance_double(File) }

    context 'given known type' do
      it 'returns expected set configuration' do
        expect(described_class.get_record_config(type, file))
          .to eq(set_name: 'Organizations', class: Tps::OrganizationRecord)
      end
    end

    context 'given unknown record type' do
      let(:type)      { :foo }
      let(:file_name) { 'some-file.json' }

      before do
        allow(File).to receive(:basename)
          .with(file)
          .and_return(file_name)
      end

      it 'returns default configuration' do
        expect(described_class.get_record_config(type, file))
          .to eq(set_name: file_name, class: Tps::Record)
      end
    end
  end

  describe '.get_name_for' do
    let(:set_name) { 'set_name' }

    before do
      allow(described_class).to receive(:get_record_config)
        .and_return(set_name: set_name, class: double)
    end

    it 'returns specified set name' do
      expect(described_class.set_name_for(:type, instance_double(File)))
        .to eq set_name
    end
  end

  describe '.record_class_for' do
    let(:klass) { double }

    before do
      allow(described_class).to receive(:get_record_config)
        .and_return(set_name: 'set', class: klass)
    end

    it 'returns record class name' do
      expect(described_class.record_class_for(:type, instance_double(File)))
        .to eq klass
    end
  end
end
