class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "conversations_#{message.conversation_id}_channel",
                                 message: render_message(message),
                                 curret_user_message: render_current_user_message(message),
                                 user_id: message.user_id
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message}
  end

  def render_current_user_message(message)
  	MessagesController.render partial: 'messages/current_user_message', locals: {message: message}
  end
end