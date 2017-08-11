require 'rails_helper'
require 'stripe_mock'

RSpec.describe Provider, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { 
  	StripeMock.start 
  }
  after { StripeMock.stop }

  let(:user) { FactoryGirl.create(:user) }
  let(:provider) { FactoryGirl.create(:provider, user: user) }

  describe "subscriptions" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:stripe_account_id) }
  end

  describe 'providers' do

		it "should create new account" do
      provider = Provider::CreateProvider.new(user, "US").call
      
      expect(provider).to be_valid
      expect(provider.stripe_account_id).not_to be_nil

      expect(provider.user.is_provider?).to be_truthy
  
	  end
	end
end
