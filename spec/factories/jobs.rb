FactoryGirl.define do
  factory :job do
    name { FactoryGirl.generate(:job_name) }
    company
    user
    location
    role
    description "My Job Description"
  end
end
