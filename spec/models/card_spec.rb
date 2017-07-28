require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:card) { FactoryGirl.build(:card) }
  
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:last4) }
    it { is_expected.to validate_presence_of(:brand) }
    it { is_expected.to validate_presence_of(:stripe_customer_id) }
    it { is_expected.to validate_presence_of(:stripe_card_id) }
    it { card.save; is_expected.to validate_uniqueness_of(:stripe_card_id).scoped_to(:user_id) }
    it { card.save; is_expected.to validate_uniqueness_of(:fingerprint).scoped_to(:user_id) }
  end

  describe 'scopes' do
    it "should only get active cards" do
      inactive_card = FactoryGirl.create(:card, active: false)
      active_card = FactoryGirl.create(:card)
      active_cards = Card.active

      expect(active_cards.count).to eq(1)
      expect(active_cards.include?(inactive_card)).to eq(false)
    end

    it "should only get chargable cards" do
      inactive_card = FactoryGirl.create(:card, active: false)
      deleted_card = FactoryGirl.create(:card, deleted_on_stripe: true)

      active_card = FactoryGirl.create(:card)
      active_cards = Card.chargeable

      expect(active_cards.count).to eq(1)
      expect(active_cards.include?(inactive_card)).to eq(false)
    end
  end
end
