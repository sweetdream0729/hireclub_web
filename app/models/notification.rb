class Notification < ApplicationRecord
  # Scopes
  scope :published,        -> { where(published: true) }
  scope :unread,           -> { where(read_at: nil) }
  scope :recent,           -> { order(created_at: :desc) }

  # Associations
  belongs_to :activity
  belongs_to :user

  # Validations
  validates :activity, presence: true
  validates :activity_key, presence: true
  validates :user, presence: true
  validates_uniqueness_of :activity_id, scope: :user_id

  # Callbacks
  before_validation :set_activity_key, on: :create

  def set_activity_key
    self.activity_key = activity.key if activity
  end
end
