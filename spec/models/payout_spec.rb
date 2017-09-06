require 'rails_helper'

RSpec.describe Payout, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:payout) { FactoryGirl.build(:payout) }

  subject { payout }

  describe "associations" do
    it { should belong_to(:payoutable) }
    it { should belong_to(:provider) }
  end

  describe 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:payoutable) }
    it { should validate_presence_of(:stripe_charge_id) }
    it { should validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(1) }
  end

  describe "transfer!" do
    it "should transfer payout for an appointment" do
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984)
      stripe_charge = Stripe::Charge.create(
        :amount => 2000,
        :currency => "usd",
        :source => card_token
      )
      payout.stripe_charge_id = stripe_charge.id
      payout.save

      payout.transfer!
      
      expect(payout.transferred_on).to be_present
    end

    it "should not transfer if already transfered" do
      transfer_time = DateTime.now
      payout.transferred_on = transfer_time
      payout.save

      payout.transfer!

      expect(payout.transferred_on).to eq(transfer_time)
    end
  end
end
