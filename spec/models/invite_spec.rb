require 'rails_helper'

RSpec.describe Invite, type: :model do
  
  let(:invite) { FactoryGirl.build(:invite) }
  
  subject { invite }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:viewed_by) }
    it { should belong_to(:recipient) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    #it { should validate_presence_of(:slug) }
    it { invite.save; should validate_uniqueness_of(:slug) }

    it { should validate_presence_of(:input) }
    it { should allow_value('test@test.com').for(:input) }
    it { should allow_value('info+test@company.co').for(:input) }
    it { should_not allow_value('company.co').for(:input) }
    it { should_not allow_value('foo').for(:input) }
  end

  context 'viewed' do
    let(:other_user) { FactoryGirl.create(:user) }

    it "#mark_viewed is true if no user" do
      invite.mark_viewed!(nil)

      expect(invite.viewed?).to eq(true)
      expect(invite.viewed_on).not_to be_nil
      expect(invite.viewed_by).to be_nil
    end

    it "#mark_viewed is true if other user" do
      invite.mark_viewed!(other_user)

      expect(invite.viewed?).to eq(true)
      expect(invite.viewed_on).not_to be_nil
      expect(invite.viewed_by).to eq(other_user)
    end

    it "#mark_viewed is false if self" do
      invite.mark_viewed!(invite.user)

      expect(invite.viewed?).to eq(false)
      expect(invite.viewed_on).to be_nil
      expect(invite.viewed_by).to be_nil
    end
  end

  describe "activity" do
    it "should have create activity" do
      invite.save

      activity = PublicActivity::Activity.where(key: InviteCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(invite)
      expect(activity.owner).to eq(invite.user)
      expect(activity.private).to eq(true)

      expect(invite.recipient).to be_nil
    end
  end

  describe "recipient" do
    let(:other_user) { FactoryGirl.create(:user) }
    it "should set recipient when matching email" do
      invite.input = other_user.email
      invite.save

      expect(invite.recipient).to eq other_user
    end
  end
end
