class Newsletter < ApplicationRecord
  # Association
  belongs_to :email_list

  # Validations
  validates_presence_of  :email_list
  validates_presence_of  :subject
  #validates_uniqueness_of  :campaign_id, allow_nil: true

  def set_name
    self.name = "Newsletter #{self.sent_on.strftime("%D %I:%M %p")}"
  end
  
  def set_campaign_id
    self.campaign_id = self.name.parameterize.gsub("-","_").downcase
  end

  def replace_html(user)
    output = self.html

    output.gsub! '{first_name}', user.first_name
    output.gsub! '{profile_link}', Rails.application.routes.url_helpers.user_url(user,:host => Rails.application.secrets.domain_name)
  end
end
