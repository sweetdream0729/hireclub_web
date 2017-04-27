class CommentCreateActivity
  KEY = "comment.create"

  def self.get_recipients_for(activity)
    comment = activity.trackable
    commentable = comment.commentable
    # send out notifications to commentable user
    recepients = [commentable.user] if commentable.user != comment.user
  end
end