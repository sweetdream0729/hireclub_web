FactoryGirl.define do
  factory :company do
    name { FactoryGirl.generate(:company_name) }
    tagline {FactoryGirl.generate(:company_tagline)}
  end
end
