require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { 
  	StripeMock.start 
  }
  after { StripeMock.stop }

  let(:user) { FactoryGirl.create(:user) }
  let(:provider) { FactoryGirl.create(:provider, user: user, phone: "8123418506", date_of_birth: DateTime.now - 20.years, state: "bihar") }
  let(:bank_account) { FactoryGirl.create(:bank_account, provider: provider) }

  describe "bank_accounts" do
    it { is_expected.to belong_to(:provider) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:stripe_bank_account_id) }
    it { is_expected.to validate_presence_of(:routing_number) }
    it { is_expected.to validate_presence_of(:bank_name) }
    it { is_expected.to validate_presence_of(:fingerprint) }
  end

  describe 'bank_accounts action' do
    
    it "should create bank account" do  
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
      bank_token = StripeMock.generate_bank_token
      bank_account = BankAccount.create_bank_account(bank_token, provider)
      expect(bank_account).to be_valid
      expect(bank_account.stripe_bank_account_id).not_to be_nil
    end
  end
end
