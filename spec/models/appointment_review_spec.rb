require 'rails_helper'

RSpec.describe AppointmentReview, type: :model do
  let(:appointment) { FactoryGirl.build(:appointment) }
  let(:appointment_review) { FactoryGirl.build(:appointment_review, appointment: appointment) }

  before do
    appointment.complete!(appointment.user)
  end

  subject { appointment_review }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:appointment) }
    it { should validate_uniqueness_of(:appointment_id).scoped_to(:user_id).case_insensitive }
    it { should validate_presence_of(:rating) }
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    
    it "should validate appointment is complete" do
      appointment.completed_on = nil
      appointment.save
      appointment_review.save

      expect(appointment_review).not_to be_valid
      expect(appointment_review.errors.full_messages.first).to eq "Appointment must be completed"
    end

    it "should require text if rating less than 5" do
      appointment_review.rating = 4
      appointment_review.save

      expect(appointment_review).not_to be_valid
      expect(appointment_review.errors.full_messages.first).to eq "Text is required"
    end
  end
end
