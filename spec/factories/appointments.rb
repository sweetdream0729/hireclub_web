FactoryGirl.define do
  factory :appointment do
    user
    acuity_id { FactoryGirl.generate(:bitcoin_address) } 
    first_name "MyString"
    last_name "MyString"
    phone "MyString"
    email "MyString"
    price_cents 6000
    amount_paid_cents 6000
    appointment_type nil
    start_time "2017-07-19 00:46:05"
    end_time "2017-07-19 00:46:05"
    timezone "MyString"
  end
end
