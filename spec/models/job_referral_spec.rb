require 'rails_helper'

RSpec.describe JobReferral, type: :model do
  let(:job_referral) { FactoryGirl.build(:job_referral) }

  subject { job_referral }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:job) }
    it { should belong_to(:sender)}
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:job) }
    it { should validate_presence_of(:sender) }
    
    it { job_referral.save; should validate_uniqueness_of(:slug) }

  end
  
  describe "refer user for job" do
    it "create job JobReferral" do
      user = FactoryGirl.create(:user)
      job = FactoryGirl.create(:job)
      user1 = FactoryGirl.build(:admin)

      user1.username = "kidbombay"
      user1.save
      user1.reload

      JobReferral.refer_user(user1, user, job)
      expect(job.job_referrals.count).to eq(1)
    end

  end
end
