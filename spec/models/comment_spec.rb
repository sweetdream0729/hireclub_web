require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build(:comment) }

  subject { comment }

  describe "associations" do
    it { should belong_to(:user)}
    it { should belong_to(:commentable)}
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:commentable) }
    it { should validate_presence_of(:text) }
  end

  describe "activity" do
    it "should have create activity" do
      comment.save
      activity = Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(comment)
      expect(activity.owner).to eq(comment.user)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      notification = notifications.first
      expect(notification.user).to eq comment.commentable.user
    end
  end
end
