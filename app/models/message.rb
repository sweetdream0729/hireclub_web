class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  # Validations
  validates :user, presence: true
  validates :conversation, presence: true
  validates :text, presence: true
end
