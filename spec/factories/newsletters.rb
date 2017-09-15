FactoryGirl.define do
  factory :newsletter do
    subject "MyString"
    preheader "MyString"
    html "MyText"
    email_list
  end
end
