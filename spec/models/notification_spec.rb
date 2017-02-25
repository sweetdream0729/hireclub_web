require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryGirl.build(:notification) }

  subject { notification }

  before do
    Notification.enabled = true
    allow(Notification).to receive(:delay).and_return(Notification)
  end

  describe "associations" do
    it { should belong_to(:user) }
    
    it { should belong_to(:activity) }
  end

  describe 'validations' do
    it { should validate_presence_of(:activity) }
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:activity_id).scoped_to(:user_id) }
  end

  context 'like.create',focus: true do
    let(:like) { FactoryGirl.create(:like) }
    it "should create notification for likeable user" do
      expect(like).to be_valid
      Notification.create_notifications_for_activity(like.activities.last.id)

      notification = Notification.last

      expect(notification).to be_present
      expect(notification.activity_key).to eq LikeCreateActivity::KEY
      expect(notification.user).to eq (like.likeable.user)

      activity = notification.activity
      expect(activity.owner).to eq(like.user)
    end
  end

end
