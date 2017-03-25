class UserWelcomeActivity
  KEY = "user.welcome"

  def self.get_recipients_for(activity)
    recepients = [activity.owner]
  end
end