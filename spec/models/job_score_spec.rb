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

    context "skills" do
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

    context "roles" do
      it "should score 5 if the user role matches" do
        user_role = FactoryGirl.create(:user_role, user: user)
        job.role = user_role.role
        job.save

        job_score.update_score

        expect(job_score.score).to eq(5)
      end
    end

    context "projects" do
      let(:project) { FactoryGirl.create(:project, user: user, skills: [skill1.name, skill2.name]) }
      
      it "should score 1 for each matching skill in project" do
        expect(project).to be_valid
        job.skills = [skill1.name, skill2.name]
        job.save
        job_score.update_score

        expect(job_score.score).to eq(2)
      end

    end

    context "location" do
      let(:california) { FactoryGirl.create(:location, name: "California", level: Location::STATE, short: "CA") }
      let(:sf) { FactoryGirl.create(:location, name: "San Francisco", parent: california, level: Location::CITY) }
      let(:mv) { FactoryGirl.create(:location, name: "Mountain View", parent: california, level: Location::CITY) }
      it "should score 5 for matching city",:focus do
        job.location = sf
        job.save

        user.location = sf
        user.save

        job_score.update_score

        expect(job_score.score).to eq(5)
      end

      it "should score 3 for location within 120 miles" do
        job.location = sf
        job.save

        user.location = mv
        user.save

        job_score.update_score

        expect(job_score.score).to eq(3)
      end
    end
  end
end
