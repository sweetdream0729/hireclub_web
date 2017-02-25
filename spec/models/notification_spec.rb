require 'rails_helper'

RSpec.describe User, type: :model do
  let(:notification) { FactoryGirl.build(:notification) }

  subject { notification }

  describe "associations" do
    it { should belong_to(:user) }
    
    it { should belong_to(:activity) }
  end

  describe 'validations' do
    it { should validate_presence_of(:activity) }
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:activity_id).scoped_to(:user_id) }
  end

end
