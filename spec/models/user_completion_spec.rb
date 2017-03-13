require 'rails_helper'

RSpec.describe UserCompletion, :type => :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:user_completion) { UserCompletion.new(user) }
  let(:randomlocation) { FactoryGirl.create(:location)}
  subject { user_completion }

  describe "associations" do
    it "should set the user" do
      expect(user_completion.user).to eq user
    end
  end

  context "percent_complete" do
    it "should return 10 for new user" do
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 20 when username set" do
      user.username = "test"
      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when website_url set" do
      user.website_url = "http://hireclub.co"
      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when bio set" do
      user.bio = "test"
      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when location set" do
      user.location = randomlocation
      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when user role set" do
      user_role = FactoryGirl.create(:user_role, user: user)
      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when 5 skills added" do
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end

      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when 3 projects added" do
      3.times do
        FactoryGirl.create(:project, user: user)
      end

      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when 5 milestones added" do
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end

      expect(user_completion.percent_complete).to eq 20
    end

    it "should return 20 when avatar set" do
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.percent_complete).to eq 20
    end
  end

  context "next_step" do
    it "should return Set Username when no username" do
      expect(user_completion.next_step).to eq "Set Username"
    end

    it "should return Set Location when no location" do
      user.username = "test"
      expect(user_completion.next_step).to eq "Set Location"
    end

    it "should return Complete Bio when no bio" do
      user.username = "test"
      user.location = randomlocation
      expect(user_completion.next_step).to eq "Complete Bio"
    end

    it "should return Add avatar when no avatar" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      expect(user_completion.next_step).to eq "Add avatar"
    end

    it "should return Add roles when no roles" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.next_step).to eq "Add roles"
    end

    it "should return Add 5 or more skills when less than 5 skills" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      expect(user_completion.next_step).to eq "Add 5 or more skills"
    end

    it "should return Add 2 or more projects when less than 2 projects" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      expect(user_completion.next_step).to eq "Add 3 or more projects"
    end

    it "should return Add 5 or more milestones when less than 5 milestones" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      expect(user_completion.next_step).to eq "Add 5 or more milestones"
    end

    it "should return Add website_url when no website_url" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end

      expect(user_completion.next_step).to eq "Add website url"
    end

    it "should return as complete profile when profile complete" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end
      user.website_url = "http://hireclub.co"
      expect(user_completion.next_step).to eq "Complete Profile"
    end

  end 

  context "next_link" do 
    it "should return /settings when no username" do
      expect(user_completion.next_link).to eq "/settings"
    end

    it "should return /settings no location" do
      user.username = "test"
      expect(user_completion.next_link).to eq "/settings"
    end

    it "should return /settings when no bio" do
      user.username = "test"
      user.location = randomlocation
      expect(user_completion.next_link).to eq "/settings"
    end

    it "should return /settings when no avatar" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      expect(user_completion.next_link).to eq "/settings"
    end

    it "should return /user_roles/new when no roles" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.next_link).to eq "/user_roles/new"
    end

    it "should return /user_skills/new when less than 5 skills" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      expect(user_completion.next_link).to eq "/user_skills/new"
    end

    it "should return /user_id/projects/new when less than 3 projects" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      id = user.id
      expect(user_completion.next_link).to eq "/#{id}/projects/new"
    end

    it "should return /milestones/new when less than 5 milestones" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      expect(user_completion.next_link).to eq "/milestones/new"
    end

    it "should return Add /settings when no website_url" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end

      expect(user_completion.next_link).to eq "/settings"
    end

    it "should return # when profile complete" do
      user.username = "test"
      user.location = randomlocation
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end
      user.website_url = "http://hireclub.co"
      expect(user_completion.next_link).to eq "#"
    end

  end 
end







