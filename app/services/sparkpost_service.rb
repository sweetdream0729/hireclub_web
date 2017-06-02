require 'simple_spark'
class SparkpostService

  def self.client
    @@client ||=  SimpleSpark::Client.new(api_key: Rails.application.secrets.sparkpost_api_key)
  end

  def self.get_message_events
    results = self.client.message_events.search
    results.each do |message_event|
      SparkpostService.create_from_sparkpost_message_event(message_event)
    end
  end

  def self.create_from_sparkpost_message_event(message_event)
    event = AnalyticsEvent.where(event_id: message_event["event_id"]).first_or_create do |event|
      event.key = "email.#{message_event['type']}"
      event.timestamp = DateTime.parse(message_event["timestamp"])
      event.data = message_event
    end
    return event
  end
end