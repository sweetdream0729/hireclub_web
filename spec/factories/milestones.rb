FactoryGirl.define do
  factory :milestone do
    user
    name { FactoryGirl.generate(:milestone_name) }
    start_date "2017-02-04"
  end
end
