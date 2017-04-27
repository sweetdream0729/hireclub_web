class NotificationMailer < ApplicationMailer
  default from: "HireClub <no-reply@hireclub.co>"

  def user_welcome(notification)
    @notification = Notification.find notification
    @user = @notification.user

    mail(to: @user.email, subject: 'Welcome to HireClub! 🍾')
  end

  def review_request(notification)
    @notification = Notification.find notification
    @user = @notification.user

    mail(to: @user.email, subject: 'Your Profile Review')
  end
end
