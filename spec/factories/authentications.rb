FactoryGirl.define do
  factory :authentication do
    user
    provider "facebook"
    uid "test"
  end
end
