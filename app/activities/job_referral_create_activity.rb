class JobReferralCreateActivity
  KEY = "job_referral.create"

  def self.get_recipients_for(activity)
    recepients = [activity.trackable.user]
  end

  def self.send_notification(notification)
    return unless notification.user.preference.email_on_follow
    NotificationMailer.refer_user(notification).deliver_later
  end
end