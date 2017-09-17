class Newsletter < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  nilify_blanks

  # Scopes
  scope :by_recent, -> {order(created_at: :asc)}

  # Association
  belongs_to :email_list
  belongs_to :published_by, class_name: 'User'

  # Validations
  validates_presence_of  :email_list
  validates_presence_of  :subject
  #validates_uniqueness_of  :campaign_id, allow_nil: true

  def set_name
    self.name = "Newsletter #{self.sent_on.strftime("%D %I:%M %p")}"
  end
  
  def set_campaign_id
    self.campaign_id = self.name.parameterize.gsub("-","_").downcase if self.campaign_id.blank?
  end

  def replace_html(user)
    return "" if html.blank?
    output = html

    output = output.gsub '{first_name}', user.first_name
    output = output.gsub '{profile_link}', Rails.application.routes.url_helpers.user_url(user,:host => Rails.application.secrets.domain_name)
    output
  end

  def publish!(user)
    return unless publishable?
    self.published_by = user
    self.save

    if Rails.env.test?
      DeliverNewsletterJob.perform_now(self)
    else
      #if self.scheduled_on.present?
        #NewsletterDeliverJob.set(wait_until: self.scheduled_on).perform_later(self)
      #else
        DeliverNewsletterJob.perform_later(self)
      #end
    end

    self.create_activity_once :publish, owner: user, private: true
  end

  def deliver!
    return if published?

    self.sent_on = DateTime.now
    self.set_name
    self.set_campaign_id
    self.save

    self.email_list.users.email_newsletter.find_each do |user|
      NewsletterMailer.newsletter(self, user).deliver_later
    end
  end

  def published?
    sent_on.present?
  end

  def publishable?
    !published? && persisted? && html.present?
  end

  def destroyable?
    !published? && !new_record?
  end
end
