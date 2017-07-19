require 'rails_helper'

RSpec.describe AppointmentType, type: :model do
  let(:appointment_type) { FactoryGirl.build(:appointment_type) }

  subject { appointment_type }

  describe "associations" do
    it { should belong_to(:appointment_category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { appointment_type.save; should validate_uniqueness_of(:name).case_insensitive }
    it { appointment_type.save; should validate_uniqueness_of(:acuity_id) }
    it { should validate_numericality_of(:price_cents).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:duration).is_greater_than_or_equal_to(0) }
  end

end
