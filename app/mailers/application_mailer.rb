class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "HireClub <no-reply@#{Rails.application.secrets.domain_name}>"
  layout 'mailer'
  after_action :set_sparkpost_header

  def set_campaign(campaign_id)
    get_sparkpost_data
    @sparkpost_data[:campaign_id] = campaign_id
    add_metadata(:campaign_id, campaign_id)
  end

  def set_tags(tags_array)
    get_sparkpost_data
    @sparkpost_data[:tags] = tags_array
    add_metadata(:tags, tags_array)
  end

  def add_metadata(key, value)
    get_sparkpost_data
    @sparkpost_data[:metadata][key] = value
  end

  def get_sparkpost_data
    @sparkpost_data ||= { metadata: {}}
  end

  def set_sparkpost_header
    headers['X-MSYS-API'] = get_sparkpost_data.to_json
  end
end
