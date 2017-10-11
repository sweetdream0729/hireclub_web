class ProjectShareCreateActivity
  KEY = "project_share.create"
  def self.get_recipients_for(activity)
    [activity.recipient]
  end

  def self.send_notification(notification)
    ProjectShareMailer.project_shared(notification).deliver_later
  end
end