FactoryGirl.define do
  factory :contact do
    email { FactoryGirl.generate(:email) }
  end
end
