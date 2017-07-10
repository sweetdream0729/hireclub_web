FactoryGirl.define do
  factory :community_member do
    community
    user
    role CommunityMember::MEMBER
  end
end
