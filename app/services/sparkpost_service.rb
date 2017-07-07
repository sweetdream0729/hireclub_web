require 'simple_spark'
class SparkpostService

  def self.client
    @@client ||=  SimpleSpark::Client.new(api_key: Rails.application.secrets.sparkpost_api_key, subaccount_id: Rails.application.secrets.sparkpost_subaccount_id)
  end

  def self.get_message_events
    results = self.client.message_events.search
    results.each do |message_event|
      SparkpostService.create_from_sparkpost_message_event(message_event)
    end
  end

  def self.create_from_sparkpost_message_event(message_event)
    Rails.logger.info message_event
    return if message_event["subaccount_id"].present? && message_event["subaccount_id"] != Rails.application.secrets.sparkpost_subaccount_id
    event = AnalyticsEvent.where(event_id: message_event["event_id"]).first_or_create do |event|
      event.key = "email.#{message_event['type']}"
      timestamp = message_event["timestamp"]
      begin
        date = DateTime.parse(timestamp)
      rescue
        date = Time.at(timestamp.to_i)
      end
      event.timestamp = date
      event.data = message_event
    end
    return event
  end
end