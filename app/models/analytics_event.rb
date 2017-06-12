class AnalyticsEvent < ApplicationRecord

  validates :event_id, :uniqueness => true, :presence => true
  validates :key, presence: true
  validates :timestamp, :presence => true


  def self.create_search_event(params, current_user, request)
    key = SearchActivity::KEY
    event_id = self.generate_event_id
    timestamp = DateTime.now
    data = params

    if current_user.present?
      data[:user_id] = current_user.id.to_s
    end

    if request.present?
      Rails.logger.info request.inspect
      data[:ip_address] = request.ip
      data[:user_agent] = request.user_agent
      data[:session_id] = request.session.id
    end
    self.create(event_id: event_id, key: key, timestamp: timestamp, data: data)
  end

  def self.generate_event_id
    event_id = loop do
      event_id = rand(999999999999999999)
      break event_id unless AnalyticsEvent.where(event_id: event_id).exists?
    end
    return event_id
  end
end
