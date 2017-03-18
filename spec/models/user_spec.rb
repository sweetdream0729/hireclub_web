require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  subject { user }

  describe "associations" do
    it { should have_many(:conversation_users) }
    it { should have_many(:conversations).through(:conversation_users) }
    it { should have_many(:notifications) }
    it { should have_many(:authentications) }
    it { should have_many(:projects) }
    it { should have_many(:milestones) }
    it { should have_many(:resumes) }
    it { should have_many(:companies).through(:milestones) }
    it { should have_many(:user_skills) }
    it { should have_many(:skills).through(:user_skills) }

    it { should have_many(:user_roles) }
    it { should have_many(:roles).through(:user_roles) }

    it { should have_many(:user_badges) }
    it { should have_many(:badges).through(:user_badges) }

    it { should belong_to(:location)}

    it { should have_many(:likes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_least(0).is_at_most(50) }

    it "should not allow invalid usernames" do
      # from route recognizers
      invalid_usernames = ["assets", "about","contact", "admin"]
      invalid_usernames += ["!","#","test name"]
      invalid_usernames.each do |username|
        user.username = username
        expect(user.valid?).to eq(false)
      end
    end

    it { is_expected.to allow_value("test.name", "5", "test_name", "test-name").for(:username) }
  end

  describe "facebook import" do
    it "should import omniauth data from facebook" do
      Location.import_cities
      json = '{"provider":"facebook","uid":"643675243","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/643675243/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAACiIAGQWrYBAKDtZB5XJwSH5nwuRheTxOZBP6LXAoBjHxZBbWqfVMkZBRE8DDTXh2aa1ODVFAtCkW8TVlNZAlwALfuUT0S71m71oksuja4JaAws7DETGjUhcFGZBLCt6gZAOLMrWSgOKUWPLeGpb4R20mDUoP3w0EZD","expires_at":1491352014,"expires":true},"extra":{"raw_info":{"id":"643675243","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"}}}}'
      omniauth = JSON.parse(json)

      user = User.from_omniauth(omniauth)

      expect(user).to be_valid
      expect(user).to be_persisted

      expect(user.email).to eq("fire@kidbombay.com")
      expect(user.name).to eq("Ketan Anjaria")
      expect(user.gender).to eq("male")
      expect(user.location).to be_present

      auth = user.authentications.first
      expect(auth).to be_present
      expect(auth).to be_valid
      expect(auth).to be_persisted

    end

    it "should import work history" do
      json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAI9Oaml4A3VSGo9jqaYxIn6MBGwyNpdoyY8JqSHO5dZAREh9HA3PFiOIZAO1K93WeJUQRTicRhgX5eOKxQRlbVKtRbGXqWgl0MfD2gJH33AGWqPF4O24h9usEtddBk98G6Wac6ZB9fyJCMvOMIZD","expires_at":1494876966,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"},"education":[{"school":{"id":"111584518860183","name":"West Springfield High"},"type":"High School","year":{"id":"137409666290034","name":"1995"},"id":"10150413024980244"},{"concentration":[{"id":"108170975877442","name":"Photography"}],"school":{"id":"32359482111","name":"The Evergreen State College"},"type":"College","year":{"id":"143018465715205","name":"2000"},"id":"10158330373725244"}],"work":[{"description":"Untz Untz UntZ","employer":{"id":"821365304544508","name":"Up All Night SF"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"106275566077710","name":"Chief technology officer"},"start_date":"2014-09-30","id":"10156584882275244"},{"employer":{"id":"1412288385651374","name":"HireClub"},"position":{"id":"849873341726582","name":"Founder"},"start_date":"2011-12-31","id":"10157862976510244"},{"employer":{"id":"294554919629","name":"kidBombay"},"position":{"id":"130875350283931","name":"CEO \u0026 Founder"},"start_date":"1999-12-01","id":"10150413024965244"},{"description":"Lead all branding and design. Kicked ass.","end_date":"2013-10-15","employer":{"id":"265831417137","name":"Samba TV"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"248173885259874","name":"Design Director"},"start_date":"2013-02-01","id":"10153326054595244"},{"end_date":"2013-03-01","employer":{"id":"490553880961257","name":"Network"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"130875350283931","name":"CEO \u0026 Founder"},"start_date":"2012-07-01","id":"10151920581535244"},{"description":"Create \u0026 Share Digital Business Cards","end_date":"2013-03-01","employer":{"id":"172171216175008","name":"CardFlick"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"107957955904825","name":"Founder (company)"},"start_date":"2011-05-01","id":"10150644885265244"}]}}}'
      omniauth = JSON.parse(json)

      user = User.from_omniauth(omniauth)

      expect(user).to be_valid
      expect(user).to be_persisted

      ImportFacebookHistoryJob.perform_now(user, omniauth)
      
      milestone = user.milestones.work.first
      expect(milestone).to be_present
      expect(milestone.title).to eq "Joined Up All Night SF as Chief technology officer"
      expect(milestone.start_date.year).to eq 2014
      expect(milestone.start_date.month).to eq 9
      expect(milestone.start_date.day).to eq 30
      expect(milestone.facebook_id).to eq "10156584882275244"
      expect(milestone.description).to eq "Untz Untz UntZ"
      expect(milestone.kind).to eq Milestone::WORK
    end

    it "should import education history" do
      json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAHf1NByZABYZCZAPIkQiJZA7WWHJt64OMBYHGGAoh9ernefABeKnkyz5KfwzIF8QtesIhJ5ux0vun8vm42IDd8UA22nttCnOxB1OUDNhSFymgOGqAQDpLUoZB7jWneEEZBs1eWacAHyZB0a8bg5sdAZD","expires_at":1494876966,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"},"education":[{"school":{"id":"111584518860183","name":"West Springfield High"},"type":"High School","year":{"id":"137409666290034","name":"1995"},"id":"10150413024980244"},{"concentration":[{"id":"108170975877442","name":"Photography"}],"school":{"id":"32359482111","name":"The Evergreen State College"},"type":"College","year":{"id":"143018465715205","name":"2000"},"id":"10158330373725244"}]}}}'
      omniauth = JSON.parse(json)

      user = User.from_omniauth(omniauth)

      expect(user).to be_valid
      expect(user).to be_persisted

      ImportFacebookHistoryJob.perform_now(user, omniauth)
      
      milestone = user.milestones.education.last
      expect(milestone).to be_present
      expect(milestone.title).to eq "Went to The Evergreen State College"
      expect(milestone.start_date.year).to eq 2000
      expect(milestone.facebook_id).to eq "10158330373725244"
      expect(milestone.kind).to eq Milestone::EDUCATION
    end

    it "should import omniauth data from linkedin" do
      json = '{"provider":"linkedin","uid":"Fs7-zkSDyL","info":{"name":"Ketan Anjaria","email":"fire@kidbombay.com","nickname":"Ketan Anjaria","first_name":"Ketan","last_name":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"description":"CTO at Up All Night SF","image":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","urls":{"public_profile":"https://www.linkedin.com/in/kidbombay"}},"credentials":{"token":"AQVARc5fzBsJzGNGX0GHGTEP8uQrVUUAyMlwib6PhO7rm5pWG3QkWjmUT2H6dLvDrQ7lsD1ChsSNIi5snVp4LDnAyefjOHYg6GKfpnKwimFCEopAwqyQqZk0dJN06JkJ_CrHwh0VEj0c98s8mwHpCNq8LY88w4F1nRjTDCmtAPv9tLwav28","expires_at":1492441756,"expires":true},"extra":{"raw_info":{"emailAddress":"fire@kidbombay.com","firstName":"Ketan","headline":"CTO at Up All Night SF","id":"Fs7-zkSDyL","industry":"Internet","lastName":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"pictureUrl":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","publicProfileUrl":"https://www.linkedin.com/in/kidbombay"}}}'
      omniauth = JSON.parse(json)

      user = User.from_omniauth(omniauth)

      expect(user).to be_valid
      expect(user).to be_persisted
      expect(user.linkedin_url).to eq "https://www.linkedin.com/in/kidbombay"

      expect(user.email).to eq("fire@kidbombay.com")
      expect(user.name).to eq("Ketan Anjaria")

      auth = user.authentications.first
      expect(auth).to be_present
      expect(auth).to be_valid
      expect(auth).to be_persisted
    end
  end

  describe "onboarded?" do
    it "should return false if no username" do
      location = FactoryGirl.create(:location)
      user.location = location
      expect(user.onboarded?).to eq(false)
    end

    it "should return false if no location" do
      user.username = "test"
      expect(user.onboarded?).to eq(false)
    end

    it "should return true if username and location" do
      location = FactoryGirl.create(:location)
      user.location = location
      user.username = "test"
      expect(user.onboarded?).to eq(true)
    end
  end

  describe "available_skills" do
    before {
      user.save
      Skill.seed
    }
    let(:user_skill) { FactoryGirl.create(:user_skill, user: user, skill: Skill.first) }

    it "should return all skills as available when none" do
      expect(user.available_skills.count).to eq Skill.count
    end

    it "should return unused skills when user skill added" do
      user_skill
      expect(user.skills.count).to eq(1)
      expect(user.available_skills.count).to eq Skill.count - 1
    end
  end

  describe "available_roles" do
    before {
      user.save
      Role.seed
    }
    let(:user_role) { FactoryGirl.create(:user_role, user: user, role: Role.first) }

    it "should return all roles as available when none" do
      expect(user.available_roles.count).to eq Role.count
    end

    it "should return unused roles when user role added" do
      user_role
      expect(user.roles.count).to eq(1)
      expect(user.available_roles.count).to eq Role.count - 1
    end
  end

  describe "search" do
    it "should search_by_name" do
      user.name = "Developer"
      user.save

      results = User.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq user      
    end

    it "should search_by_exact_name" do
      user.name = "Developer"
      user.save

      results = User.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq user      
    end
  end

  describe "activity" do
    it "should have create activity" do
      user.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(user)
      expect(activity.owner).to eq(user)
    end
  end

  describe "key_words" do
    let(:user) { FactoryGirl.create(:user) }

    it "should have roles by position" do
      FactoryGirl.create(:user_role, user: user, position: 0) 
      FactoryGirl.create(:user_role, user: user, position: 10)
      FactoryGirl.create(:user_role, user: user, position: 3)
      user.save 
      # nil added to the end to simulate the addition of further meta tags
      keywords = user.user_roles.by_position.limit(3).map(&:name) + [nil]
      expect(user.key_words).to eq(keywords) 
    end

    it "should have skills by position" do 
      FactoryGirl.create(:user_skill, user: user, position: 10)
      FactoryGirl.create(:user_skill, user: user, position: 11)
      FactoryGirl.create(:user_skill, user: user, position: 12)
      FactoryGirl.create(:user_skill, user: user, position: 13)
      FactoryGirl.create(:user_skill, user: user, position: 14)
      user.save
      # nil added to the end to simulate the addition of further meta tags

      keywords = user.user_skills.by_position.limit(5).map(&:name) + [nil]
      expect(user.key_words).to eq(keywords)
    end 
  end

  describe "website_url" do
    it "should add http if missing" do
      user.website_url = "instagram.com/username"
      expect(user.website_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      user.website_url = "www.instagram.com/username"
      expect(user.website_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      user.website_url = "foo"
      expect(user.website_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:website_url) }
  end

  describe "instagram_url" do
    it "should add http if missing" do
      user.instagram_url = "instagram.com/username"
      expect(user.instagram_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      user.instagram_url = "www.instagram.com/username"
      expect(user.instagram_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      user.instagram_url = "foo"
      expect(user.instagram_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:instagram_url) }
  end
end
