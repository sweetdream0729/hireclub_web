FactoryGirl.define do
  factory :email_list do
    name  { FactoryGirl.generate(:username) }
  end
end
