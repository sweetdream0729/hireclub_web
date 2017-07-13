require 'rails_helper'

RSpec.describe CommunityInvitePolicy do

  subject { CommunityInvitePolicy.new(user, community_invite) }

  let(:user) { FactoryGirl.create(:user) }
  let(:owner) { FactoryGirl.create(:user) }
  let(:community_invite) { FactoryGirl.create(:community_invite, sender: owner) }
  
  context 'being a visitor' do
    let(:user) { nil }

    it { should forbid_action(:show) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being the owner' do
    let(:user) { owner }
    it { should permit_action(:show) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'being an another user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should forbid_action(:show) }
    it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.create(:admin) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'being an recipient' do
    let(:user) { community_invite.user }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

end
