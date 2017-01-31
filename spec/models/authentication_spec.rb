require 'rails_helper'

RSpec.describe Authentication, :type => :model do
  let(:authentication) { FactoryGirl.create(:authentication) }

  subject { authentication }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_inclusion_of(:provider).in_array(Authentication::VALID_PROVIDERS) }
  end

  describe "from_omniauth" do
    it "should create an auth from facebook omniauth hash" do
      json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAJYKLDRbqpyPVhvm3QvB3FZAvvJgd71nqV5KE7zBMLmZCtlZBwnLUTMfKcN6gceHubTUnWymKrHpON3uYZASErRBTQoRyZAOVOtvRqBtpwEiso9dyZB4sNvxiOrwFfXRHzGLUlppJE9ux4zZCUh2UkZD","expires_at":1491064746,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"}}}}
'
      omniauth = JSON.parse(json)

      user = FactoryGirl.create(:user)

      auth = Authentication.new
      auth.user = user
      auth.from_omniauth(omniauth)

      expect(auth).to be_valid
      expect(auth.user).to eq(user)
      expect(auth.provider).to eq("facebook")
      expect(auth.uid).to eq(omniauth["uid"])
      expect(auth.token).to eq(omniauth['credentials']['token'])
      expect(auth.expires).to eq(false)
      expect(auth.omniauth_json).not_to be_nil
    end
  end
  
end
