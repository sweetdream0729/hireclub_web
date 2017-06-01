class ConversationsChannel < ApplicationCable::Channel

  def subscribed
    current_user.conversations.find_each do |conversation|
      stream_from "conversations:#{conversation.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    @conversation = Conversation.find(data["conversation_id"])
    message   = @conversation.messages.create(text: data["text"], user: current_user)
    @conversation.update_unread_counts
    MessageRelayJob.perform_later(message)
    UserPresenceJob.perform_later(current_user.id, "active")
  end

  #for creating message.unread activity which will send push notification to user 
  def send_unread_notification(data)
    message = Message.find( data['message_id'])
    user = User.find(data['user_id'])
    message.create_activity_once key: MessageUnreadActivity::KEY, owner: user, published: false, private: true, recipient: message.conversation
  end

  def update_title_count
    TitleCountJob.perform_later(current_user)
  end

end
