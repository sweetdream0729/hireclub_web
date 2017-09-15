class Preference < ApplicationRecord
  attr_accessor :unsubscribe_all
  belongs_to :user

  # Scope
  scope :email_newsletter,       -> { where(email_newsletter: true) }
  
  # Validations
  validates :user, presence: true, uniqueness: true

  before_save :check_unsubscribe_all

  def check_unsubscribe_all
    if ActiveModel::Type::Boolean.new.cast(self.unsubscribe_all)
      self.email_on_follow = false
      self.email_on_comment = false
      self.email_on_mention = false
      self.email_on_unread = false
      self.email_on_job_post = false
      self.email_on_event_publish = false
      self.email_newsletter = false
    end
  end
end
