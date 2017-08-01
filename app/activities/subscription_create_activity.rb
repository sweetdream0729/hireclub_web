class SubscriptionCreateActivity
  KEY = "subscription.create"

  def self.get_recipients_for(activity)
    [activity.trackable.user]
  end
end