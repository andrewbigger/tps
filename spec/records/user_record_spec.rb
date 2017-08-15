require 'spec_helper'

describe Tps::UserRecord do
  let(:id) { 1 }
  let(:external_id) { 2 }
  let(:organization_id) { 3 }
  let(:tags) { ['a', 'b', 'c'] }
  let(:role) { 'agent' }
  let(:name) { 'Jane Smith' } 

  let(:params) do
    {
      _id: id,
      external_id: external_id,
      organization_id: organization_id,
      tags: tags,
      role: role,
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

  describe '#organization_id_compare' do
    before { subject.organization_id_compare(organization_id) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(organization_id, organization_id)
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

  describe '#role_compare' do
    before { subject.role_compare(role) }

    it 'delegates match to string_equal?' do
      expect(subject).to have_received(:string_equal?)
        .with(role, role)
    end
  end
end
