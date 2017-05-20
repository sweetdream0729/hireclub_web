class MessageRelayJob < ApplicationJob
  queue_as :critical

  def perform(message)
    ActionCable.server.broadcast "conversations:#{message.conversation.id}", {
      username: message.user.username,
      text: message.text,
      conversation_id: message.conversation.id
    }
  end

  # def perform(message)
  #   conversation_user = ConversationUser.where.not(user_id: message.user_id).last
  #   ActionCable.server.broadcast "conversations_#{message.conversation_id}_channel",
  #                                message: render_message(message),
  #                                curret_user_message: render_current_user_message(message),
  #                                user_id: message.user_id,
  #                                conversation_id: message.conversation_id,
  #                                text: message.text,
  #                                created_at: ApplicationController.helpers.time_ago_in_words(message.created_at),
  #                                unread_count: conversation_user.unread_messages_count
  # end

  # private

  # def render_message(message)
  #   MessagesController.render partial: 'messages/message', locals: {message: message}
  # end

  # def render_current_user_message(message)
  # 	MessagesController.render partial: 'messages/current_user_message', locals: {message: message}
  # end

end