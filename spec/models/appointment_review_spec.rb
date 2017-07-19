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
  end
end
