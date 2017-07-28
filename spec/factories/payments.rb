FactoryGirl.define do
  factory :payment do
    processor "MyString"
    external_id { FactoryGirl.generate(:bitcoin_address) }
    amount_cents 100
    paid_on { DateTime.now }
    payable { FactoryGirl.build(:appointment) }
  end
end
