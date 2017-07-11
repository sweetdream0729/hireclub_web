class PostCreateActivity
  KEY = "post.create"

  def self.get_recipients_for(activity)
    post = activity.trackable
    community = post.community
    # send out notifications to members
    recepients = community.users - [post.user]
    recepients
  end

  def self.send_notification(notification)
    #return unless notification.user.preference.email_on_comment
    NotificationMailer.post_created(notification).deliver_later
  end
end