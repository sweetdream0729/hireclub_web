FactoryGirl.define do
  factory :community do
    name { FactoryGirl.generate(:company_name) }
  end
end
