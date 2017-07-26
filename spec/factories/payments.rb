FactoryGirl.define do
  factory :payment do
    processor "MyString"
    external_id "MyString"
    amount_cents 100
  end
end
