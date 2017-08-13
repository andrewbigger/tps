require 'spec_helper'

describe Tix::CLI::Command do
  let(:session) { double(Tix::CLI::Session) }
  subject { described_class.new(session) }

  it 'caches session' do
    expect(subject.instance_variable_get(:@session))
      .to eq session
  end
end
