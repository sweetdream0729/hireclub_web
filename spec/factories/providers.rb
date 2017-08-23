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
    state "CA"
    tos_acceptance_date "2017-08-11 14:08:40"
    tos_acceptance_ip "MyString"
    ssn { FactoryGirl.generate(:ssn) }
    user
    phone { FactoryGirl.generate(:phone) }
    date_of_birth "1987-09-01"
  end
end
