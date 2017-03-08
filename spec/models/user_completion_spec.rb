require 'rails_helper'

RSpec.describe UserCompletion, :type => :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:user_completion) { UserCompletion.new(user) }
  subject { user_completion }

  describe "associations" do
    it "should set the user" do
      expect(user_completion.user).to eq user
    end
  end

  context "percent_complete" do
    it "should return 0 for new user" do
      expect(user_completion.percent_complete).to eq 0
    end

    it "should return 10 when username set" do
      user.username = "test"
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when website_url set" do
      user.website_url = "http://hireclub.co"
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when bio set" do
      user.bio = "test"
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when location set" do
      user.location = Location.new
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when location set" do
      user_role = FactoryGirl.create(:user_role, user: user)
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 5 skills added" do
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 3 projects added" do
      3.times do
        FactoryGirl.create(:project, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 5 milestones added" do
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when avatar set" do
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.percent_complete).to eq 10
    end
  end
end