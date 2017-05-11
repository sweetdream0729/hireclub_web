class Message < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Scopes
  scope :by_recent, -> {order(created_at: :asc)}

  # Associations
  belongs_to :user
  belongs_to :conversation
  counter_culture :conversation, touch: true

  # Validations
  validates :user, presence: true
  validates :conversation, presence: true
  validates :text, presence: true

  # Callbacks
  after_commit :update_unread_counts, on: :create

  def create_conversation_user
    conversation_user = conversation.conversation_users.where(user: user, conversation: conversation).first_or_create
  end

  def update_unread_counts
    create_conversation_user.update_unread_messages_count
    broadcast_job
  end

  def broadcast_job
    MessageBroadcastJob.perform_now(self) unless Rails.env.test?
  end

  def read_by!(read_by_user)
    return if read_by_user == user
    self.create_activity_once key: MessageReadActivity::KEY, owner: read_by_user, published: false, private: true, recipient: conversation
  end

  def is_read?
    activities.where(key: MessageReadActivity::KEY).any?
  end

  def is_read_by?(read_by_user)
    activities.where(key: MessageReadActivity::KEY, owner: read_by_user).any?
  end
end
