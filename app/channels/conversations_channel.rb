class ConversationsChannel < ApplicationCable::Channel

  # def subscribed
  #   stream_from "conversations_#{params['conversation_id']}_channel"
  # end
  # def send_message(data)
  #   message = Message.create!(text: data['text'], conversation_id: data['conversation_id'], user_id: current_user.id)
  # end

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
    message   = @conversation.messages.create(body: data["text"], user: current_user)
    MessageRelayJob.perform_later(message)
  end


end