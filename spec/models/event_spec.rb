require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryGirl.build(:event) }

  subject { event }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:location) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    #it { should validate_presence_of(:slug) }
    # it { event.save; should validate_uniqueness_of(:slug).case_insensitive }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:source_url) }
    it { should validate_presence_of(:location) }



    it "should validate end_time is after start_time" do
      event.end_time = DateTime.now
      event.start_time = DateTime.now + 1.hour

      expect(event).to be_invalid
    end
  end

  describe "source_url" do
    it "should add http if missing" do
      event.source_url = "instagram.com/username"
      expect(event.source_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      event.source_url = "www.instagram.com/username"
      expect(event.source_url).to eq("http://www.instagram.com/username")
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:source_url) }
  end

  describe 'publish!' do
    it "publishes the event" do
      other_user = FactoryGirl.create(:user)
      other_user.follow(event.user)

      event.save
      expect(event).to be_valid
      event.publish!

      expect(event.published?).to eq(true)
      expect(event.published_on).not_to be_nil

      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.key).to eq EventPublishActivity::KEY
      expect(activity.trackable).to eq(event)
      expect(activity.owner).to eq(event.user)
      expect(activity.private).to eq(false)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      
      notification = notifications.first
      expect(notification.user).to eq other_user
    end
  end
end
