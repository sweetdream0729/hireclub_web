class Preference < ApplicationRecord
  attr_accessor :unsubscribe_all
  belongs_to :user

  # Validations
  validates :user, presence: true, uniqueness: true

  before_save :check_unsubscribe_all

  def check_unsubscribe_all
    self.email_on_follow = false
    self.email_on_comment = false
    self.email_on_mention = false
  end
end
