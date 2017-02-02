FactoryGirl.define do
  factory :skill do
    name { FactoryGirl.generate(:company_name) }
  end
end
