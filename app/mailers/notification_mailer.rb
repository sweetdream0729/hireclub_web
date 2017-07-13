class NotificationMailer < ApplicationMailer

  def user_welcome(notification)
    set_notification(notification)

    @url_url = get_utm_url user_url(@user)

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

  def post_created(notification)
    set_notification(notification)

    @post = @notification.activity.trackable
    @community = @post.community

    add_metadata(:post_id, @post.id)
    add_metadata(:community, @community.id)

    @post_url = get_utm_url url_for(@post)
    @post_user_url = get_utm_url url_for(@post.user)

    mail(to: @user.email, subject: "New Post in the #{@community.name} community")
  end

  def comment_created(notification)
    set_notification(notification)

    @comment = @notification.activity.trackable
    @commentable = @comment.commentable

    @commentable_url = get_utm_url url_for(@commentable)
    @comment_user_url = get_utm_url url_for(@comment.user)

    mail(to: @user.email, subject: 'New Comment')
  end

  def comment_mentioned(notification)
    set_notification(notification)

    @comment = @notification.activity.trackable.mentionable
    @commentable = @comment.commentable

    @commentable_url = get_utm_url url_for(@commentable)
    @comment_user_url = get_utm_url url_for(@comment.user)

    mail(to: @user.email, subject: 'New Mention')
  end

  def job_created(notification)
    set_notification(notification)

    @job = @notification.activity.trackable
    @company = @job.company

    @job_url = get_utm_url url_for(@job)
    @user_url = get_utm_url url_for(@job.user)
    @company_url = get_utm_url url_for(@company)

    mail(to: @user.email, subject: "#{@job.company.name} posted job #{@job.name}")
  end

  def story_published(notification)
    set_notification(notification)

    @story = @notification.activity.trackable

    @story_url = get_utm_url url_for(@story)

    mail(to: @user.email, subject: "#{@story.user.display_name} published #{@story.name}")
  end

  def project_created(notification)
    set_notification(notification)

    @project = @notification.activity.trackable

    @project_url = get_utm_url url_for(@project)

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

  def invite_bounced(notification)
    set_notification(notification)
    @invite = @notification.activity.trackable
    @invite_url = url_for(@invite)

    add_metadata(:invite_id, @invite.id)

    @subject = "Your invite to #{@invite.input} bounced"
    mail(to: @user.email, subject: @subject)
  end

  def community_invited(notification)
    set_notification(notification)
    @community_invite = @notification.activity.trackable
    @sender = @community_invite.sender
    @community = @community_invite.community

    @community_url = url_for(@community)
    @sender_url = url_for(@sender)

    add_metadata(:community_invite_id, @community_invite.id)
    add_metadata(:community_id, @community.id)

    @subject = "#{@sender.display_name} invited you to the #{@community.name} community"
    mail(to: @user.email, subject: @subject)
  end

  def conversation_unread(notification)
    set_notification(notification)
    @conversation_user = @notification.activity.trackable
    @conversation = @conversation_user.conversation
    @conversation_url = url_for(@conversation)

    add_metadata(:conversation_user_id, @conversation_user.id)
    add_metadata(:conversation_id, @conversation.id)

    @subject = "You have a message on HireClub"
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
