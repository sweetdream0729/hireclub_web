require 'rails_helper'
require 'stripe_mock'

RSpec.describe Subscription, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { 
  	StripeMock.start 
  	stripe_plan = stripe_helper.create_plan(:id => "1", :amount => 500, name: 'Hero')
  }
  after { StripeMock.stop }

  let(:user) { FactoryGirl.create(:user) }
  let(:subscription) { FactoryGirl.create(:subscription, user: user) }
  
  describe "subscriptions" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to validate_presence_of(:status) }
  end

   describe 'Subscribing' do

   	  it "should return a plan" do
   	  	plan = subscription.get_plan
   	  	expect(plan["id"]).to eq("1")
   	  end

   	  it "should start subscription" do
          subscription = Subscription::CreateSubscription.new(user, stripe_helper.generate_card_token, {}).call
	      
	      expect(subscription).to be_valid
	      expect(subscription.stripe_subscription_id).not_to be_nil
	      expect(subscription.status).to eq(Subscription::ACTIVE)
	      expect(subscription.stripe_plan_id).to eq('1')
	      expect(subscription.stripe_plan_name).to eq('Hero')
	      expect(subscription.price_cents).to eq(500)

	      expect(subscription.user.is_subscriber).to eq(true)
	  
      end

      it "should cancel subscription" do
        subscription = Subscription::CreateSubscription.new(user, stripe_helper.generate_card_token, {}).call

        subscription.cancel

        expect(subscription).to be_persisted
        expect(subscription.status).to eq(Subscription::CANCELED)
        expect(subscription.stripe_subscription_id).not_to be_nil
        expect(subscription.canceled_at).not_to be_nil

        expect(subscription.user.is_subscriber).to eq(false)
      end
   end
end
