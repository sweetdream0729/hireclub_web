require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryGirl.build(:post) }

  subject { post }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:community) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:community) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end


  describe "activity" do

    it "should have create activity" do
      post.save
      activity = Activity.where(key: PostCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(post)
      expect(activity.owner).to eq(post.user)
    end
  end
end
