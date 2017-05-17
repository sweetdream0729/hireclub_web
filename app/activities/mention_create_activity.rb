class MentionCreateActivity
  KEY = "mention.create"

  def self.get_recipients_for(activity)
    [activity.trackable.user]
  end
end