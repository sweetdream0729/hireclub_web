require 'rails_helper'

RSpec.describe UserRole, type: :model do
  let(:user_role) { FactoryGirl.build(:user_role) }

  subject { user_role }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }

    it { should validate_uniqueness_of(:role_id).scoped_to(:user_id) }
  end
end
