FactoryGirl.define do
  factory :community_invite do
    community
    user
    sender { FactoryGirl.build(:user) }
  end
end
