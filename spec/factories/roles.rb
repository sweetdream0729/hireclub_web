FactoryGirl.define do
  factory :role do
    name { FactoryGirl.generate(:company_name) }
  end
end
