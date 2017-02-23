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

    it "should create an auth from linkedin omniauth" do

      json = '{"provider":"linkedin","uid":"Fs7-zkSDyL","info":{"name":"Ketan Anjaria","email":"fire@kidbombay.com","nickname":"Ketan Anjaria","first_name":"Ketan","last_name":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"description":"CTO at Up All Night SF","image":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","urls":{"public_profile":"https://www.linkedin.com/in/kidbombay"}},"credentials":{"token":"AQVARc5fzBsJzGNGX0GHGTEP8uQrVUUAyMlwib6PhO7rm5pWG3QkWjmUT2H6dLvDrQ7lsD1ChsSNIi5snVp4LDnAyefjOHYg6GKfpnKwimFCEopAwqyQqZk0dJN06JkJ_CrHwh0VEj0c98s8mwHpCNq8LY88w4F1nRjTDCmtAPv9tLwav28","expires_at":1492441756,"expires":true},"extra":{"raw_info":{"emailAddress":"fire@kidbombay.com","firstName":"Ketan","headline":"CTO at Up All Night SF","id":"Fs7-zkSDyL","industry":"Internet","lastName":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"pictureUrl":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","publicProfileUrl":"https://www.linkedin.com/in/kidbombay"}}}'
      omniauth = JSON.parse(json)

      user = FactoryGirl.create(:user)

      auth = Authentication.new
      auth.user = user
      auth.from_omniauth(omniauth)

      expect(auth).to be_valid
      expect(auth.user).to eq(user)
      expect(auth.provider).to eq("linkedin")
      expect(auth.uid).to eq(omniauth["uid"])
      expect(auth.token).to eq(omniauth['credentials']['token'])
      expect(auth.expires).to eq(false)
      expect(auth.username).to eq("kidbombay")
      expect(auth.omniauth_json).not_to be_nil
    end
  end
  
end
