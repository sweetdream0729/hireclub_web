require 'rails_helper'

RSpec.describe OnesignalService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  let(:player_id) { "4dc96072-62f9-44c7-a75b-c6ca388360a9" }

  it "should create a notification for all users" do
    params = {
      included_segments: ["All"],
      contents: {
        en: 'All Users'
      },
      ios_badgeType: 'Increase',
      ios_badgeCount: 1
    }
    OnesignalService.create_notification(params)
  end

  it "should create a notification for specific player" do
    params = {
      include_player_ids: [player_id],
      contents: {
        en: 'Specific Player'
      },
      ios_badgeType: 'Increase',
      ios_badgeCount: 1
    }
    OnesignalService.create_notification(params)
  end

  it "should create a notification for specific user" do
    params = {
      contents: {
        en: 'Specific User'
      },
      ios_badgeType: 'Increase',
      ios_badgeCount: 1
    }
    OnesignalService.create_notification_for(user, params)
  end

  it "should set tags for a specific player" do
    id = player_id
    params = {
      tags: {
        user_id: 1
      }
    }

    OnesignalService.update_player(id, params)
  end

  context "notifications" do
    let(:user2) { FactoryGirl.create(:user, name: 'Testy') }

    it "should send notification for follow user" do
      user
      user2.follow(user)
     
      activity = Activity.where(key: UserFollowActivity::KEY, owner: user2).first
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity.id)
      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)

      notification = notifications.first
      UserFollowActivity.send_push(notification)
    end

  end
end