FactoryGirl.define do
  factory :appointment_type do
    name { FactoryGirl.generate(:name) }
    acuity_id { FactoryGirl.generate(:bitcoin_address) } 
  end
end
