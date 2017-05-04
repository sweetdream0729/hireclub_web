class Message < ApplicationRecord
  # Extensions
  include UnpublishableActivity
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
end
