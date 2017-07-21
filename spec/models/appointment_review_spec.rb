require 'rails_helper'

RSpec.describe AppointmentReview, type: :model do
  let(:appointment) { FactoryGirl.build(:appointment) }
  let(:appointment_review) { FactoryGirl.build(:appointment_review, appointment: appointment) }

  subject { appointment_review }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:appointment) }
    it { should validate_presence_of(:rating) }
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    it { should validate_uniqueness_of(:appointment_id).with_message('can have only one review') }

    it "appointment should complete before adding review" do
      user = FactoryGirl.create(:user)
      appointment.user = user
      appointment.save
      before_count = AppointmentReview.count
      appointment.complete!(user)
      review = FactoryGirl.create(:appointment_review, appointment: appointment)
      expect(AppointmentReview.count).not_to eq(before_count)
    end

  end
end
