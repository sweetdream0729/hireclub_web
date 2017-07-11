FactoryGirl.define do
  factory :post do
    user
    community
    text "Hello"
  end
end
