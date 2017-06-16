class NotificationMailer < ApplicationMailer

  def user_welcome(notification)
    set_notification(notification)

    mail(to: @user.email, subject: 'Welcome to HireClub! 🍾')
  end

  def review_request(notification)
    set_notification(notification)

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
    set_notification(notification)

    @comment = @notification.activity.trackable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Comment')
  end

  def comment_mentioned(notification)
    set_notification(notification)

    @comment = @notification.activity.trackable.mentionable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Mention')
  end

  def job_created(notification)
    set_notification(notification)

    @job = @notification.activity.trackable
    @company = @job.company
    mail(to: @user.email, subject: "#{@job.company.name} posted job #{@job.name}")
  end

  def story_published(notification)
    set_notification(notification)

    @story = @notification.activity.trackable

    mail(to: @user.email, subject: "#{@story.user.display_name} published #{@story.name}")
  end

  def project_created(notification)
    set_notification(notification)

    @project = @notification.activity.trackable

    mail(to: @user.email, subject: "#{@project.user.display_name} added project #{@project.name}")
  end

  def user_followed(notification)
    set_notification(notification)

    @follower = notification.activity.owner
    @following = @user.following?(@follower)

    @follower_url = get_utm_url user_url(@follower)
    @follow_url = get_utm_url follow_user_url(@follower)
    
    if @following
      @subject = "#{@follower.display_name} followed you back on HireClub"
    else
      @subject = "#{@follower.display_name} followed you on HireClub"
    end
    mail(to: @user.email, subject: @subject)
  end

  def set_notification(notification)
    @notification = Notification.find(notification.id)
    @user = @notification.user

    if @notification.present?
      set_campaign(@notification.activity_key)
      add_metadata(:notification_id, @notification.id)
      add_metadata(:user_id, @user.try(:id))
      add_metadata(:activity_id, @notification.try(:activity).try(:id))
    end
  end

end
