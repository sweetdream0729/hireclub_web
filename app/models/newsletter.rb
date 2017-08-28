class Newsletter < ApplicationRecord

  # Validations
  validates_presence_of  :subject
  validates_uniqueness_of  :campaign_id, allow_nil: true

  def set_name
    self.name = "Newsletter #{self.sent_on.strftime("%D %I:%M %p")}"
  end
  
  def set_campaign_id
    self.campaign_id = self.name.parameterize.gsub("-","_").downcase
  end
end
