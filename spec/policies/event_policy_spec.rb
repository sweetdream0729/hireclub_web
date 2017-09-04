require 'rails_helper'

RSpec.describe EventPolicy do

  subject { EventPolicy.new(user, event) }

  let(:event) { FactoryGirl.build(:event) }
  let(:user) { FactoryGirl.build(:user) }

  context 'being a visitor' do
    let(:user) { nil }

    it { should permit_action(:show) }
    it { should forbid_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
    it { should forbid_action(:publish) }
  end

  context 'being the owner' do
    let(:user) { event.user }
    it { should permit_action(:show) }
    it { should forbid_action(:create) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
    it { should permit_action(:publish) }
  end

  context 'being an another user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should permit_action(:show) }
    it { should forbid_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
    it { should forbid_action(:publish) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.build(:admin) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
    it { should permit_action(:publish) }
  end


end
