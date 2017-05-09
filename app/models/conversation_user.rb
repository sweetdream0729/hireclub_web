class ConversationUser < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: { scope: :conversation_id }

  def update_unread_messages_count
    count = 0
    conversation.messages.where.not(user: user).find_each do |message|
      count += 1 unless message.is_read_by?(user)
    end
    self.unread_messages_count = count
    self.save
  end
end
