# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def user_welcome
    user = User.first
    user.welcome!
    notification = Notification.where(user: user, activity_key: UserWelcomeActivity::KEY).first
    NotificationMailer.user_welcome(notification)
  end

  def review_request
    review_request = ReviewRequest.first
    notification = Notification.where(user: review_request.user, activity_key: ReviewRequestCreateActivity::KEY).first
    NotificationMailer.review_request(notification)
  end
end
