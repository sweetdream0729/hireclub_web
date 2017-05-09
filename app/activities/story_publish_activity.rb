class StoryPublishActivity
  KEY = "story.publish"

  # def self.get_recipients_for(activity)
  #   # Company followers except person who posted story
  #   recepients = activity.trackable.company.followers + User.admin - [activity.trackable.user]
  # end

  # def self.send_notification(notification)
  #   NotificationMailer.delay.story_created(notification)
  # end

end