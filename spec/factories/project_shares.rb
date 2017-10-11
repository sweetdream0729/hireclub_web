FactoryGirl.define do
  factory :project_share do
    user
    project
    input { FactoryGirl.generate(:email) }
  end
end
