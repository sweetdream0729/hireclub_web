require 'rails_helper'

RSpec.describe AppointmentCategory, type: :model do
  let(:appointment_category) { FactoryGirl.build(:appointment_category) }

  subject { appointment_category }

  describe "associations" do
    it { should have_many(:appointment_types) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { appointment_category.save; should validate_uniqueness_of(:name).case_insensitive }

    it { appointment_category.save; should validate_uniqueness_of(:slug).case_insensitive }
    
  end
end
