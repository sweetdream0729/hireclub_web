FactoryGirl.define do
  factory :analytics_event do
    event_id Faker::Bitcoin.address
    key "my.event"
    timestamp DateTime.now
  end
end
