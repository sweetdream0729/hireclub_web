FactoryGirl.define do
  factory :provider do
    stripe_account_id "MyString"
    first_name "MyString"
    last_name "MyString"
    city "MyString"
    country "MyString"
    address_line_1 "MyText"
    address_line_2 "MyText"
    postal_code "MyString"
    tos_acceptance_date "2017-08-11 14:08:40"
    tos_acceptance_ip "MyString"
    ssn_last_4 "MyString"
    user nil
  end
end
