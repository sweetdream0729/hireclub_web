class Message < ApplicationRecord
  # Scopes
  scope :by_recent, -> {order(created_at: :asc)}

  belongs_to :user
  belongs_to :conversation

  # Validations
  validates :user, presence: true
  validates :conversation, presence: true
  validates :text, presence: true
end
