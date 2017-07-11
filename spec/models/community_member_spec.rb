require 'rails_helper'

RSpec.describe CommunityMember, type: :model do
  let(:community_member) { FactoryGirl.build(:community_member) }

  subject { community_member }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:community) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:community) }
    it { community_member.save; is_expected.to validate_uniqueness_of(:community_id).scoped_to(:user_id) }

    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_inclusion_of(:role).in_array(CommunityMember::ROLES) }
  end

  describe "activity" do
    let(:user) { FactoryGirl.create(:user) }
    let(:community) { FactoryGirl.create(:community) }

    it "should have community.join activity once" do
      user.join_community(community)
      user.join_community(community)
      
      activities = PublicActivity::Activity.where(key: CommunityJoinActivity::KEY)
      expect(activities.count).to eq 1

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(community)
    end

    it "should have community.leave activity" do
      user.join_community(community)
      user.leave_community(community)
      user.join_community(community)
      user.leave_community(community)
      
      
      activities = PublicActivity::Activity.where(key: CommunityLeaveActivity::KEY)
      expect(activities.count).to eq 2

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(community)
      expect(activity.published).to eq(false)
    end
  end

end
