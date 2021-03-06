module Trackable
  extend ActiveSupport::Concern

  def set_campaign(campaign_id)
    get_sparkpost_data
    @campaign_id = campaign_id
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

  def get_utm_url(url)
    "#{url}?utm_source=transactional&utm_medium=email&utm_campaign=#{@campaign_id}"
  end
end
