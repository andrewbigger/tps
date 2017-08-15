require 'spec_helper'

describe Tps::OrganizationRecord do
  let(:id) { 1 }
  let(:external_id) { 2 }
  let(:domain_names) { ['a.com', 'b.com', 'c.com'] }
  let(:tags) { %w[a b c] }
  let(:name) { 'Giant Corp' }

  let(:params) do
    {
      _id: id,
      external_id: external_id,
      domain_names: domain_names,
      tags: tags,
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
      expect(subject).to have_received(:string_equal?)
        .with(id, id)
    end
  end

  describe '#external_id_compare' do
    before { subject.external_id_compare(external_id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(external_id, external_id)
    end
  end

  describe '#domain_names_compare' do
    let(:domain_search) { 'a.com' }
    before { subject.domain_names_compare(domain_search) }

    it 'delegates match to array_equal?' do
      expect(subject).to have_received(:array_include?)
        .with(domain_names, domain_search)
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
end
