class AssigneeCreateActivity
  KEY = "assignee.create"

  def self.get_recipients_for(activity)
    [activity.trackable.user]
  end

  def self.send_notification(notification)
    NotificationMailer.appointment_assigned(notification).deliver_later
  end
end