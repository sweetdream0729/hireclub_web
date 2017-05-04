class MessageCreateActivity
  KEY = "message.create"

  def self.get_recipients_for(activity)
    message = activity.trackable
    recepients = message.conversation.users - [message.user]
  end
end