class NotificationMailer < ApplicationMailer
  default from: "HireClub <no-reply@hireclub.co>"

  def user_welcome(notification)
    @notification = Notification.find notification
    @user = @notification.user

    mail(to: @user.email, subject: 'Welcome to HireClub! 🍾')
  end

  def comment_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @comment = @notification.activity.trackable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Comment')
  end
end
