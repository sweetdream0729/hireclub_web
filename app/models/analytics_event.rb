class AnalyticsEvent < ApplicationRecord

  validates :event_id, :uniqueness => true, :presence => true
  validates :key, presence: true
  validates :timestamp, :presence => true

end
