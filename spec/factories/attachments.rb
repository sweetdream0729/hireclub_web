FactoryGirl.define do
  factory :attachment do
    link "MyString"
    attachable { FactoryGirl.create(:appointment) }
  end
end
