FactoryGirl.define do
  factory :user do
    email { FactoryGirl.generate(:email) }
    password "testtest"
    password_confirmation {|u| u.password }    

    factory :admin do
      after(:build) {|user| user.is_admin = true }
    end

    factory :moderator do
      after(:build) {|user| user.is_moderator = true }
    end
  end
end
