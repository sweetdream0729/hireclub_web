require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { FactoryGirl.create(:role) }

  subject { role }

  describe "associations" do
    # it { should have_many(:user_roles) }
    # it { should have_many(:users).through(:user_roles) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'seed' do
    it "should seed roles" do
      Role.seed
      expect(Role.all.count).to be >= 1
    end
  end

end