FactoryGirl.define do
  factory :appointment_category do
    name { FactoryGirl.generate(:name) }
  end
end
