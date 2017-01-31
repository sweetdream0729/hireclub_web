FactoryGirl.define do
  factory :user do
    email { FactoryGirl.generate(:email) }
    password "testtest"
    password_confirmation {|u| u.password }    
  end
end
