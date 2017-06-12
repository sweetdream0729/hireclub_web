FactoryGirl.define do
  factory :invite do
    user
    input { FactoryGirl.generate(:email) }
  end
end
