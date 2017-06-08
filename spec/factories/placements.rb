FactoryGirl.define do
  factory :placement do
    placeable { FactoryGirl.build(:story) }
    start_time DateTime.now
    end_time DateTime.now + 1.day
  end
end
