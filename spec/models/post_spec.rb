require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:community) { FactoryGirl.build(:community) }
  let(:user)      { FactoryGirl.build(:user) }
  let(:post)      { FactoryGirl.build(:post, community: community, user: user) }

  subject { post }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:community) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:community) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end


  describe "activity" do

    it "should have create activity" do
      community.save
      user.join_community(community)
      user2 = FactoryGirl.create(:user)
      user2.join_community(community)

      post.save

      activity = Activity.where(key: PostCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(post)
      expect(activity.owner).to eq(post.user)

      CreateNotificationJob.perform_now(activity)

      notifications = Notification.where(activity: activity)

      expect(notifications.count).to eq(1)

      notification = notifications.first
      expect(notification.user).to eq user2
    end
  end

  describe "mentions" do
    let(:kidbombay) {FactoryGirl.create(:user, username: "kidbombay")}
    let(:other_user) {FactoryGirl.create(:user, username: "test.user3")}
    
    it "should let you mention users by username" do
      post.text = "hey @#{kidbombay.username} you should meet @#{other_user.username}"

      expect(post.mentioned_users.size).to eq(2)
      expect(post.mentioned_users[0]).to eq(kidbombay)
      expect(post.mentioned_users[1]).to eq(other_user)
    end

    it "should create mentions on save" do
      post.text = "hey @#{kidbombay.username} you should meet @#{other_user.username}"
      post.save

      expect(post.mentions.size).to eq(2)
      mention = post.mentions.first
      expect(mention.user).to eq(kidbombay)
      expect(mention.sender).to eq(post.user)
      expect(mention.mentionable).to eq(post)
    end
  end
end
