FactoryGirl.define do
  factory :appointment_review do
    appointment
    rating 5
    user
  end
end
