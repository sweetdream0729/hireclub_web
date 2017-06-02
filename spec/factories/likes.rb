FactoryGirl.define do
  factory :like do
    user
    likeable { FactoryGirl.create(:milestone) }
  end
end
