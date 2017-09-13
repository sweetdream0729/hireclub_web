FactoryGirl.define do
  factory :provider do
    stripe_account_id "MyString"
    first_name "MyString"
    last_name "MyString"
    city "SF"
    country "US"
    address_line_1 "MyText"
    address_line_2 "MyText"
    postal_code 94016
    state "CA"
    tos_acceptance_date "2017-08-11 14:08:40"
    tos_acceptance_ip "127.0.0.1"
    ssn { FactoryGirl.generate(:ssn) }
    user
    phone "14155551212"
    date_of_birth "1987-09-01"
    id_proof { File.new("#{Rails.root}/spec/support/fixtures/image.png") }
  end
end
