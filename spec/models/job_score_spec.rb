require 'rails_helper'

RSpec.describe JobScore, type: :model do
  let(:job_score) { FactoryGirl.build(:job_score) }
  let(:job) { job_score.job }
  let(:user) { job_score.user }
  
  subject { job_score }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:job) }
  end

  describe 'validations' do
    it { should validate_presence_of(:job) }
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:job_id) }
    it { should validate_numericality_of(:score).is_greater_than_or_equal_to(0) }
  end

  describe "update_score" do
    let(:skill1) { FactoryGirl.create(:skill) }
    let(:skill2) { FactoryGirl.create(:skill) }
    before do
      job.skills << skill1.name
      job.save
      user.skills << skill1
      user.save
    end

    it "should score 1 for matching skill" do
      job_score.update_score

      expect(job_score.score).to eq(1)
    end

    it "should score 1 for each matching skill" do
      job.skills << skill2.name
      job.save
      user.skills << skill2
      user.save

      job_score.update_score

      expect(job_score.score).to eq(2)
    end

    it "should score 1 + number of years for each matching skill" do
      user_skill = user.user_skills.first
      user_skill.years = 5
      user_skill.save
      
      job_score.update_score

      expect(job_score.score).to eq(5)
    end
  end
end
