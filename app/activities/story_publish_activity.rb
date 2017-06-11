class StoryPublishActivity
  KEY = "story.publish"

  def self.get_recipients_for(activity)
    # Story User followers
    recepients = activity.trackable.user.followers + User.admin - [activity.trackable.user]
  end

  def self.send_notification(notification)
    NotificationMailer.story_published(notification).deliver_later
  end

end