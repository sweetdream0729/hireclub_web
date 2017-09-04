FactoryGirl.define do
  factory :event do
    name "My Event"
    start_time DateTime.now + 1.hour
    source_url "http://hireclub.com"
    user
    location
  end
end
