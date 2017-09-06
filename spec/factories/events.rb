FactoryGirl.define do
  factory :event do
    name "My Event"
    start_time DateTime.now + 1.hour
    end_time  DateTime.now + 2.hours
    source_url "http://hireclub.com"
    user
    location
  end
end
