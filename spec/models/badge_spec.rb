require 'rails_helper'

RSpec.describe Badge, type: :model do
  let(:badge) { FactoryGirl.create(:badge) }

  subject { badge }

  describe "associations" do
    it { should have_many(:user_badges) }
    it { should have_many(:users).through(:user_badges) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'seed' do
    it "should seed badges" do
      Badge.seed
      count = Badge.all.count
      expect(count).to be >= 2

      Badge.seed
      new_count = Badge.all.count
      expect(count).to eq new_count
    end
  end

  describe "search" do
    it "should search_by_name" do
      badge.name = "Developer"
      badge.save

      results = Badge.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq badge    
    end

    it "should search_by_exact_name" do
      badge.name = "Developer"
      badge.save

      results = Badge.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq badge      
    end
  end

end