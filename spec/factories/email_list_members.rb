FactoryGirl.define do
  factory :email_list_member do
    email { FactoryGirl.generate(:email) }
    email_list
    user
  end
end
