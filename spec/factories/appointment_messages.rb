FactoryGirl.define do
  factory :appointment_message do
    user
    appointment
    text "Hello"
  end
end
