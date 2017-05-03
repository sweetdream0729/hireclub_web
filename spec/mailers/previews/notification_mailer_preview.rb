# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def user_welcome
    user = User.first
    user.welcome!
    notification = Notification.where(user: user, activity_key: UserWelcomeActivity::KEY).first
    NotificationMailer.user_welcome(notification)
  end

  def review_request_user
    review_request = ReviewRequest.last
    activity = Activity.where(trackable: review_request).first
    notification = Notification.where(user: review_request.user, activity: activity).first
    NotificationMailer.review_request(notification)
  end

  def review_request_reviewer
    review_request = ReviewRequest.last
    activity = Activity.where(trackable: review_request).first
    notification = Notification.where(user: User.reviewers.last, activity: activity).first
    NotificationMailer.review_request(notification)
  end

  def comment_created
    notification = Notification.where(activity_key: CommentCreateActivity::KEY).first
    NotificationMailer.comment_created(notification)
  end
end
