require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.build(:project) }

  subject { project }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:slug).scoped_to(:user_id).case_insensitive }
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
end