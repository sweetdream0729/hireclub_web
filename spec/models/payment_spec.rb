require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { FactoryGirl.build(:payment) }

  subject { payment }

  describe "associations" do
    it { should belong_to(:payable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:payable) }
    it { should validate_presence_of(:external_id) }
    it { should validate_presence_of(:amount_cents) }
    it { should validate_presence_of(:paid_on) }
    it { should validate_presence_of(:processor) }
    it { should validate_uniqueness_of(:external_id).scoped_to(:processor) }
  end
    
  it "should convert dollars to cents" do
    payment.amount_dollars = "300.00"
    expect(payment.amount_cents).to eq 30000

    payment.amount_dollars = "$300.00"
    expect(payment.amount_cents).to eq 30000
  end
end
