FactoryGirl.define do
  factory :card do
    user
    stripe_card_id { FactoryGirl.generate(:bitcoin_address)}
    stripe_customer_id { FactoryGirl.generate(:bitcoin_address)}
    fingerprint { FactoryGirl.generate(:bitcoin_address)}
    last4 "9999"
    brand "Visa"
  end
end
