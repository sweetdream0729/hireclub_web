class ConversationsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "conversations_#{params['conversation_id']}_channel"
  end

  def send_message(data)
    Message.create!(text: data['text'], conversation_id: data['conversation_id'], user_id: current_user.id)
  end
end