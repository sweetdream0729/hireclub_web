require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  let(:user_skill) { FactoryGirl.create(:user_skill) }

  subject { user_skill }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:skill) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:skill) }
    it { should validate_numericality_of(:years).is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:skill_id).scoped_to(:user_id) }
  end
end
