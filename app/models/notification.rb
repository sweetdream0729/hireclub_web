class Notification < ApplicationRecord
  @@enabled = true

  SKIP_ACTIVITIES = [
    "user.create",
    "project.create"
  ]
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

  def read?
    read_at.present?
  end

  def self.create_notifications_for_activity(activity_id)
    #puts "Notification.create_notifications_for_activity #{activity_id}"
    activity = Activity.where(id: activity_id).first
    return false if activity.nil? || skip_notifications?(activity)

    #puts "   #{activity.inspect}"
    users = self.get_recipients_for(activity)

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

    #puts "Notification.create_notification_for #{activity}, #{user}"
    Notification.create(activity: activity, user: user)
  end

  def self.skip_notifications?(activity)
    SKIP_ACTIVITIES.include?(activity.key)
  end

  def self.get_recipients_for(activity)
    key = activity.key
    #puts "Notification.get_recipients_for #{key}"

    class_name = key.titlecase.delete(".").delete(" ") + "Activity"

    klass = class_name.constantize
    
    return klass.get_recipients_for(activity) if klass && klass.respond_to?(:get_recipients_for)
    
    raise "Please implement notification for activity #{key}"
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
