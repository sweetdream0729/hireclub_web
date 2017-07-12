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

    it "should validate user is not already member" do
      community_member = FactoryGirl.create(:community_member, user: community_invite.user, community: community_invite.community)

      expect(community_invite).to be_invalid
    end
  end

  describe "activity" do
    it "should have create activity" do
      community_invite.save

      activity = PublicActivity::Activity.where(key: CommunityInviteCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(community_invite)
      expect(activity.owner).to eq(community_invite.sender)
      expect(activity.recipient).to eq(community_invite.user)
      expect(activity.private).to eq(true)

      CreateNotificationJob.perform_now(activity)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq 1

      notification = notifications.first
      expect(notification.user).to eq(community_invite.user)
    end
  end
end
