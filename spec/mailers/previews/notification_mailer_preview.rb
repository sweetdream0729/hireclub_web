# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def user_welcome
    user = User.first
    user.welcome!
    notification = Notification.where(user: user, activity_key: UserWelcomeActivity::KEY).last
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
    notification = Notification.where(activity_key: CommentCreateActivity::KEY, published: true).last
    NotificationMailer.comment_created(notification)
  end

  def comment_mentioned
    notification = Notification.where(activity_key: MentionCreateActivity::KEY, published: true).last
    NotificationMailer.comment_mentioned(notification)
  end

  def provider_created
    notification = Notification.where(activity_key: ProviderCreateActivity::KEY).last
    NotificationMailer.provider_created(notification)
  end

  def job_created
    notification = Notification.where(activity_key: JobCreateActivity::KEY, published: true).last
    NotificationMailer.job_created(notification)
  end

  def job_referred
    notification = Notification.where(activity_key: JobReferralCreateActivity::KEY).last
    NotificationMailer.job_referred(notification)
  end

  def user_followed
    notification = Notification.where(activity_key: UserFollowActivity::KEY).last
    NotificationMailer.user_followed(notification)
  end

  def story_published
    notification = Notification.where(activity_key: StoryPublishActivity::KEY, published: true).last
    NotificationMailer.story_published(notification)
  end

  def project_created
    notification = Notification.where(activity_key: ProjectCreateActivity::KEY, published: true).last
    NotificationMailer.project_created(notification)
  end

  def invite_bounced
    notification = Notification.where(activity_key: InviteBounceActivity::KEY).last
    NotificationMailer.invite_bounced(notification)
  end

  def conversation_unread
    notification = Notification.where(activity_key: ConversationUserUnreadActivity::KEY).last
    NotificationMailer.conversation_unread(notification)
  end

  def post_created
    notification = Notification.where(activity_key: PostCreateActivity::KEY).last
    NotificationMailer.post_created(notification)
  end

  def post_mentioned
    notification = Notification.where(activity_id: Mention.where(mentionable_type: "Post").last.activities.last.id).last
    NotificationMailer.post_mentioned(notification)
  end
  
  def community_invited
    notification = Notification.where(activity_key: CommunityInviteCreateActivity::KEY).last
    NotificationMailer.community_invited(notification)
  end

  def job_referred
    notification = Notification.where(activity_key: JobReferralCreateActivity::KEY).last
    NotificationMailer.job_referred(notification)
  end

  def appointment_messaged
    notification = Notification.where(activity_key: AppointmentMessageCreateActivity::KEY).last
    NotificationMailer.appointment_messaged(notification)
  end

  def appointment_completed
    notification = Notification.where(activity_key: AppointmentCompleteActivity::KEY).last
    NotificationMailer.appointment_completed(notification)
  end
  
  def appointment_reviewed
    notification = Notification.where(activity_key: AppointmentReviewCreateActivity::KEY).last
    NotificationMailer.appointment_reviewed(notification)
  end

  def appointment_rescheduled
    notification = Notification.where(activity_key: AppointmentRescheduleActivity::KEY).last
    NotificationMailer.appointment_rescheduled(notification)
  end
end
