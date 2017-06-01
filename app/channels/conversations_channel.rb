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

  #for sending notification to user if he hasn't read the message
  def send_notification(data)
    activity = Activity.where(trackable_id: data['message_id'],key: "message.create").first
    user = User.find(data['user_id'])
    Notification.create_notification_for(activity,user)
  end

  def update_title_count
    TitleCountJob.perform_later(current_user)
  end

end
