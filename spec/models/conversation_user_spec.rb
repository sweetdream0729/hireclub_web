require "rails_helper"

RSpec.describe ConversationUser, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:conversation) { Conversation.between([user]) }
  let(:conversation_user) { conversation.conversation_users.first }

  subject { conversation_user }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe "validations" do
    it { should validate_uniqueness_of(:user_id).scoped_to(:conversation_id) }
  end

  describe "update_last_read_at" do
    it "should update_last_read_at" do
      conversation_user.update_last_read_at
      expect(conversation_user.last_read_at).to be_present
    end
  end

  describe "unread_messages_count" do
    let(:other_user) { FactoryGirl.create(:user) }

    it "should calculate unread_messages_count" do
      message1 = FactoryGirl.create(:message, user: user, conversation: conversation)
      message2 = FactoryGirl.create(:message, user: other_user, conversation: conversation)
      message3 = FactoryGirl.create(:message, user: user, conversation: conversation)

      conversation.users = [user, other_user]
      conversation.save

      expect(conversation.conversation_users.count).to eq(2)

      conversation_user = conversation.conversation_users.first
      conversation_user.update_unread_messages_count
      expect(conversation_user.unread_messages_count).to eq(1)

      other_conversation_user = conversation.conversation_users.last
      other_conversation_user.update_unread_messages_count
      expect(other_conversation_user.unread_messages_count).to eq(2)

      conversation_user.update_unread_messages_count
      expect(conversation_user.unread_messages_count).to eq(1)

      message1.read_by!(other_user)
      other_conversation_user.update_unread_messages_count
      expect(other_conversation_user.unread_messages_count).to eq(1)

      message2.read_by!(user)
      conversation_user.update_unread_messages_count
      expect(conversation_user.unread_messages_count).to eq(0)

      message3.read_by!(other_user)
      other_conversation_user.update_unread_messages_count
      expect(other_conversation_user.unread_messages_count).to eq(0)
    end
  end

  describe "notify unread" do
    it "should be false if unread_messages_count is 0" do
      conversation_user.unread_messages_count = 0
      conversation_user.save

      notified = conversation_user.notify_unread!
      conversation_user.reload

      expect(notified).to be false
      expect(conversation_user.unread_notified).to be false

      activity = Activity.where(key: ConversationUserUnreadActivity::KEY).last
      expect(activity).to be_nil
    end

    it "should be false if unread_messages_count is 1 and unread_notified is true" do
      conversation_user.unread_messages_count = 1
      conversation_user.unread_notified = true
      conversation_user.save

      notified = conversation_user.notify_unread!
      conversation_user.reload

      expect(notified).to be false
      
      activity = Activity.where(key: ConversationUserUnreadActivity::KEY).last
      expect(activity).to be_nil
    end

    it "should be true if unread_messages_count is 1 and unread_notified is false" do
      conversation_user.unread_messages_count = 1
      conversation_user.unread_notified = false
      conversation_user.save

      notified = conversation_user.notify_unread!
      conversation_user.reload

      expect(notified).to be true
      expect(conversation_user.unread_notified).to be true

      activity = Activity.where(key: ConversationUserUnreadActivity::KEY).last
      
      expect(activity).to be_present
      expect(activity.key).to eq ConversationUserUnreadActivity::KEY
      expect(activity.trackable).to eq conversation_user
      expect(activity.owner).to eq conversation_user.user
      expect(activity.private).to be true
      expect(activity.published).to be true
    end
  end

end
