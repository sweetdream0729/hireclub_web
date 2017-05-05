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
    @activity = @notification.activity
    @review_request = @activity.trackable
    @owner = @review_request.user

    if @owner == @user
      subject = "Your Profile Review"
      template_name = "review_request"
    else
      subject = "#{@owner.display_name} is asking for a profile review"
      template_name = "review_request_reviewer"
    end
    mail(to: @user.email, subject: subject, template_name: template_name)
  end

  def comment_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @comment = @notification.activity.trackable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Comment')
  end

  def job_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @job = @notification.activity.trackable
    @company = @job.company
    mail(to: @user.email, subject: "#{@job.company.name} posted job #{@job.name}")
  end
  
end
