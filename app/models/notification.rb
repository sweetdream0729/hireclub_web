class Notification < ApplicationRecord
  @@enabled = true

  SKIP_ACTIVITIES = [
    "user.create"
  ]

  NOT_MESSAGES = [
    MessageCreateActivity::KEY,
    MessageUnreadActivity::KEY,
    ConversationUserUnreadActivity::KEY
  ]

  # Scopes
  scope :published,          -> { where(published: true) }
  scope :unread,             -> { where(read_at: nil) }
  scope :recent,             -> { order(created_at: :desc) }
  scope :not_messages,       -> { where.not(activity_key: NOT_MESSAGES) }

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
  after_commit :send_email, on: :create


  def set_activity_key
    self.activity_key = activity.key if activity
  end

  def send_email
    klass = Notification.get_activity_class(activity_key)
    return klass.send_notification(self) if klass && klass.respond_to?(:send_notification)
  end

  def read?
    read_at.present?
  end

  def payload
    return {
      id: id,
      user_id: user_id,
      activity_id: activity_id,
      activity_key: activity.key,
      is_read: read?,
      read_at: read_at.to_i,
      created_at: created_at.to_i,
      updated_at: updated_at.to_i
    }
  end

  def self.create_notifications_for_activity(activity_id)
    activity = Activity.where(id: activity_id).first
    return false if activity.nil? || skip_notifications?(activity)

    users = self.get_recipients_for(activity)
    return if users.nil?

    if users.is_a? Array
      users.each do |recipient|
        create_notification_for(activity, recipient)
      end
    else
      users.find_each do |recipient|
        create_notification_for(activity, recipient)
      end
    end
  end

  def self.create_notification_for(activity, user)
    return if activity.nil? || user.nil?
    return if Notification.where(activity: activity, user: user).exists?

    Notification.create(activity: activity, user: user)
  end

  def self.skip_notifications?(activity)
    SKIP_ACTIVITIES.include?(activity.key)
  end

  def self.get_recipients_for(activity)
    begin
      klass = Notification.get_activity_class(activity.key)

      return nil unless klass.present? && klass.respond_to?(:get_recipients_for)
      return klass.get_recipients_for(activity)
    rescue
      return nil
    end
  end

  def self.get_activity_class(key)
    class_name = key.titlecase.delete(".").delete(" ") + "Activity"
    klass = class_name.constantize
  end

  def self.mark_as_read(scope)
    scope.unread.update_all(read_at: Time.now)
  end

  def self.enabled= (value)
    @@enabled = value
  end

  def self.enabled
    @@enabled
  end
end
