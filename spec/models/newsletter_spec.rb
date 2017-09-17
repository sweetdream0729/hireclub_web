require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  
  let(:newsletter) { FactoryGirl.build(:newsletter) }

  subject { newsletter }

  describe "associations" do
    
  end

  describe 'validations' do
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:email_list) }
    #it { newsletter.save; should validate_uniqueness_of(:campaign_id).allow_nil }
  end

  describe "name" do
    it "should have a name based on sent_on" do
      newsletter.sent_on = DateTime.now

      expect(newsletter.set_name).to eq("Newsletter #{newsletter.sent_on.strftime('%D %I:%M %p')}")
      expect(newsletter.set_campaign_id).to eq(newsletter.name.parameterize.gsub("-","_").downcase)
    end 
  end

  describe "publish!" do
    it "should publish newsletter" do
      user = FactoryGirl.create(:admin)
      newsletter.save

      newsletter.publish!(user)

      newsletter.reload

      expect(newsletter.sent_on).not_to be_nil
      expect(newsletter.published_by).to eq(user)

      activity = Activity.where(key: NewsletterPublishActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(newsletter)
      expect(activity.owner).to eq(user)
      expect(activity.private).to eq(true)

      CreateNotificationJob.perform_now(activity)

      notification = Notification.last
      expect(notification).to be_present
      expect(notification.user).to eq(user)
    end
  end
end
