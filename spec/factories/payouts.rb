FactoryGirl.define do
  factory :payout do
    provider
    payoutable { FactoryGirl.build(:appointment) } 
    amount_cents 100
    stripe_charge_id { FactoryGirl.generate(:bitcoin_address) } 
  end
end
