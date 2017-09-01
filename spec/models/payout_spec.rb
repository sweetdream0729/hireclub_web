require 'rails_helper'

RSpec.describe Payout, type: :model do
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
end
