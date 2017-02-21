require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.build(:project, name: nil) }

  subject { project }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:slug).scoped_to(:user_id).case_insensitive }
  end

  describe "broadcasts" do
    it "broadcasts update_project on save" do
      expect { project.save }.to broadcast(:update_project, project)
    end

    it "broadcasts update_project on destroy" do
      expect { project.destroy }.to broadcast(:update_project, project)
    end
  end

  describe "activity" do
    it "should have create activity" do
      project.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(project)
      expect(activity.owner).to eq(project.user)
    end
  end

  describe "badges" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      Badge.seed
    end

    it "should reward project badge after 3 milestones" do
      3.times do 
        FactoryGirl.create(:project, user: user)
      end
      expect(user.projects.count).to eq 3

      user_badge = user.user_badges.first
      expect(user_badge).to be_present
      expect(user_badge.name).to eq "ProPro"
    end
  end
end