require 'spec_helper'

describe Tps::TicketRecord do
  let(:id) { 1 }
  let(:external_id) { 2 }
  let(:submitter_id) { 3 }
  let(:assignee_id) { 4 }
  let(:tags) { ['a', 'b', 'c'] }
  let(:name) { 'Jane Smith' } 

  let(:params) do
    {
      _id: id,
      external_id: external_id,
      tags: tags,
      submitter_id: submitter_id,
      assignee_id: assignee_id,
      name: name
    }
  end

  before do
    allow(subject).to receive(:string_equal?)
    allow(subject).to receive(:array_include?)
    allow(subject).to receive(:string_match?)
  end

  subject { described_class.new(params) }

  describe '#_id_compare' do
    before { subject._id_compare(id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?).with(id, id)
    end
  end

  describe '#external_id_compare' do
    before { subject.external_id_compare(external_id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(external_id, external_id)
    end
  end

  describe '#tags_compare' do
    let(:tag_search) { 'a' }
    before { subject.tags_compare(tag_search) }

    it 'delegates match to array_equal?' do
      expect(subject).to have_received(:array_include?)
        .with(tags, tag_search)
    end
  end

    describe '#submitter_id_compare' do
    before { subject.submitter_id_compare(submitter_id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(submitter_id, submitter_id)
    end
  end

  describe '#assignee_id_compare' do
    before { subject.assignee_id_compare(assignee_id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(assignee_id, assignee_id)
    end
  end
end
