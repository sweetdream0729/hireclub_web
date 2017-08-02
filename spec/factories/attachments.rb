FactoryGirl.define do
  factory :attachment do
    link "https://hireclub.com"
    attachable { FactoryGirl.create(:appointment) }
  end
end
