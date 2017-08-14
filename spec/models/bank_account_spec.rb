require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { 
  	StripeMock.start 
  }
  after { StripeMock.stop }

  let(:user) { FactoryGirl.create(:user) }
  let(:provider) { FactoryGirl.create(:provider, user: user) }
  let(:bank_account) { FactoryGirl.create(:bank_account, provider: provider) }

  describe "subscriptions" do
    it { is_expected.to belong_to(:provider) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:stripe_bank_account_id) }
    it { is_expected.to validate_presence_of(:routing_number) }
    it { is_expected.to validate_presence_of(:bank_name) }
    it { is_expected.to validate_presence_of(:fingerprint) }
  end

end
