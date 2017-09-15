class NewsletterPublishActivity
  KEY = "newsletter.publish"

  def self.get_recipients_for(activity)
    User.admin
  end

end
