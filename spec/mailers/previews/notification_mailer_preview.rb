# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def user_welcome
    user = User.first
    user.welcome!
    notification = Notification.where(user: user, activity_key: UserWelcomeActivity::KEY).first
    NotificationMailer.user_welcome(notification)
  end

  def comment_created
    notification = Notification.where(activity_key: CommentCreateActivity::KEY).first
    NotificationMailer.comment_created(notification)
  end
end
