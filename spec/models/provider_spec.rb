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
    it { is_expected.to validate_presence_of(:tos_acceptance_ip) }
    it { is_expected.to validate_presence_of(:tos_acceptance_ip) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:ssn_last_4) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:address_line_1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:postal_code) }
  end

  describe 'providers' do

		it "should create new account" do
      params = {first_name: "test",
                last_name: "name",
                ssn_last_4: "1234",
                phone: "0000000000",
                date_of_birth: "01-01-2001",
                address_line_1: "test",
                city: "SF",
                state: "CA",
                country: "US",
                postal_code: "111111"}

      provider = Provider::CreateProvider.new(user, params ,"127.0.0.1").call
      
      expect(provider).to be_valid
      expect(provider.stripe_account_id).not_to be_nil

      expect(provider.user.is_provider?).to be_truthy
  
	  end
	end
end
