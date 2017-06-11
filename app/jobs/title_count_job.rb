class TitleCountJob < ApplicationJob
  queue_as :urgent

  def perform(current_user)
      ActionCable.server.broadcast "Title Update:#{current_user.id}", {
        total_count: current_user.unread_messages_count
      }
  end
end
