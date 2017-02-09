require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  let(:user_skill) { FactoryGirl.build(:user_skill) }

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

  describe "broadcasts" do
    it "broadcasts update_user_skill on save" do
      expect { user_skill.save }.to broadcast(:update_user_skill, user_skill)
    end

    it "broadcasts update_user_skill on destroy" do
      expect { user_skill.destroy }.to broadcast(:update_user_skill, user_skill)
    end
  end

  describe "years experience" do
    it "should update user.years_experience on create" do
      user_skill.years = 1
      user_skill.save

      expect(user_skill.user.years_experience).to eq(1)
    end

  end
end
