require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  subject { user }

  describe "associations" do
    it { should have_many(:authentications) }
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
      json = '{"provider":"facebook","uid":"10154112674905244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/10154112674905244/picture","location":"San Francisco, California"},"credentials":{"token":"CAADZBqzEIZB9UBAOG2GpsXPmEe0OGzRpJneajHbnLkl1bEom5mj7W1VqZAl5b3h0Q8eWMhCRc3Poqkkttbary0TokborCK3UCXa56SHvVLuMwSJoFJqZALknZAiAss458DYTfdpMWmp9op9tfW5Q522KwBRqEtannxwVra97F3pYK7NYJFusLmUH74hQI0jGcriZCZCyifp0AZDZD","expires_at":1405445165,"expires":true},"extra":{"raw_info":{"id":"10154112674905244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"}}}}'
      omniauth = JSON.parse(json)

      user = User.from_omniauth(omniauth)

      expect(user).to be_valid
      expect(user).to be_persisted

      expect(user.email).to eq("fire@kidbombay.com")
      expect(user.name).to eq("Ketan Anjaria")
      
      auth = user.authentications.first
      expect(auth).not_to be_nil
      expect(auth).to be_valid
      expect(auth).to be_persisted
    end
  end
end
