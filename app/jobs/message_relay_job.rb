class MessageRelayJob < ApplicationJob
  queue_as :critical

  def perform(message)
    ActionCable.server.broadcast "conversations:#{message.conversation.id}", {
      conversation_id: message.conversation.id,
      message: message.to_json,
      message_partial: render_message(message)
    }
  end

  # private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message}
  end

  # def render_current_user_message(message)
  # 	MessagesController.render partial: 'messages/current_user_message', locals: {message: message}
  # end

end