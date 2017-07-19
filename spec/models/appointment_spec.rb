require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:appointment) { FactoryGirl.build(:appointment) }

  subject { appointment }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment_type) }
    it { should have_many(:appointment_messages) }
    it { should have_many(:participants).through(:appointment_messages) }
  end

  describe 'validations' do
    it { should validate_presence_of(:acuity_id) }
    it { appointment.save; should validate_uniqueness_of(:acuity_id) }
  end

  describe 'cancel' do
    it "should cancel!" do
      appointment.cancel!

      expect(appointment.canceled_at).not_to be_nil
      expect(appointment.canceled?).to eq true
      expect(appointment.active?).to eq false
      expect(appointment.status).to eq "Canceled"
    end
  end
end
