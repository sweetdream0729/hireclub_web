class Activity < PublicActivity::Activity
  include Admin::ActivityAdmin

  scope :by_recent,    -> { order(created_at: :desc) }
  scope :unpublished,  -> { where(published: false) }
  scope :published,    -> { where(published: true) }
  scope :only_public,  -> { where(private: false) }
  scope :only_private, -> { where(private: true) }

end

PublicActivity::Activity.class_eval do
  has_many :notifications, dependent: :destroy
  
  after_commit :create_notifications, on: :create

  def create_notifications
    CreateNotificationJob.perform_later(self.id) if Notification.enabled
  end
end