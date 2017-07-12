require 'rails_helper'

RSpec.describe CommunityInvite, type: :model do
  let(:community_invite) { FactoryGirl.build(:community_invite) }

  subject { community_invite }

  describe 'associations' do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:community) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:sender) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:community) }
    it { community_invite.save; is_expected.to validate_uniqueness_of(:slug) }
    it { community_invite.save; is_expected.to validate_uniqueness_of(:user_id).scoped_to(:community_id, :sender_id) }    

    it "should validate sender can't be user" do
      community_invite.user = community_invite.sender
      
      expect(community_invite).to be_invalid
    end

  end
end
