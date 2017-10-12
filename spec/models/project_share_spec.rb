require 'rails_helper'

RSpec.describe ProjectShare, type: :model do
  let(:project_share) { FactoryGirl.build(:project_share) }
  
  subject { project_share }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should belong_to(:viewed_by) }
    it { should belong_to(:recipient) }
    it { should belong_to(:contact) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:project) }
    #it { should validate_presence_of(:slug) }
    it { project_share.save; should validate_uniqueness_of(:slug) }

    it { should validate_presence_of(:input) }
    it { should allow_value('test@test.com').for(:input) }
    it { should allow_value('info+test@company.co').for(:input) }
    it { should_not allow_value('company.co').for(:input) }
    it { should_not allow_value('foo').for(:input) }
  end

  context 'viewed' do
    let(:other_user) { FactoryGirl.create(:user) }

    it "#mark_viewed is true if no user" do
      project_share.mark_viewed!(nil)

      expect(project_share.viewed?).to eq(true)
      expect(project_share.viewed_on).not_to be_nil
      expect(project_share.viewed_by).to be_nil
    end

    it "#mark_viewed is true if other user" do
      project_share.mark_viewed!(other_user)

      expect(project_share.viewed?).to eq(true)
      expect(project_share.viewed_on).not_to be_nil
      expect(project_share.viewed_by).to eq(other_user)
    end

    it "#mark_viewed is false if self" do
      project_share.mark_viewed!(project_share.user)

      expect(project_share.viewed?).to eq(false)
      expect(project_share.viewed_on).to be_nil
      expect(project_share.viewed_by).to be_nil
    end
  end

  describe "activity" do
    it "should have create activity" do
      project_share.save

      activity = PublicActivity::Activity.where(key: ProjectShareCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(project_share)
      expect(activity.owner).to eq(project_share.user)
      expect(activity.private).to eq(true)

      expect(project_share.recipient).to be_nil
      expect(project_share.contact).to be_present

    end
  end

  describe "recipient" do
    let(:other_user) { FactoryGirl.create(:user) }
    it "should set recipient when matching email" do
      project_share.input = other_user.email
      project_share.save

      expect(project_share.recipient).to eq other_user
      expect(project_share.contact).to be_nil

      activity = PublicActivity::Activity.where(key: ProjectShareCreateActivity::KEY).last
      expect(activity).to be_present
      
      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present
      expect(notification.user).to eq(other_user)
    end
  end
end
