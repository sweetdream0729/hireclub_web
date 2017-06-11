class ReviewRequestCreateActivity
  KEY = "review_request.create"

  def self.get_recipients_for(activity)
    recepients = [activity.owner] + User.reviewers
  end

  def self.send_notification(notification)
    NotificationMailer.review_request(notification).deliver_later
  end
end