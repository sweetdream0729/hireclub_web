FactoryGirl.define do
  factory :subscription do
    price_cents 0
    status Subscription::PENDING
  end
end
