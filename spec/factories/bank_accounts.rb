FactoryGirl.define do
  factory :bank_account do
    stripe_bank_account_id "MyString"
    provider nil
    bank_name "MyString"
    routing_number "MyString"
    country "MyString"
    fingerprint "MyString"
  end
end
