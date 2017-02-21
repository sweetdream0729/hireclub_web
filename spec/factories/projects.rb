FactoryGirl.define do
  factory :project do
    name { FactoryGirl.generate(:company_name) }
    user
  end
end
