require 'rails_helper'

RSpec.describe Milestone, type: :model do
  let(:milestone) { FactoryGirl.build(:milestone) }

  subject { milestone }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end


  describe "activity" do
    it "should have create activity" do
      milestone.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(milestone)
      expect(activity.owner).to eq(milestone.user)
    end
  end
end