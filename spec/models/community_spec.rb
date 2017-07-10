require 'rails_helper'

RSpec.describe Community, type: :model do
  let(:community) { FactoryGirl.build(:community) }

  subject { community }

  describe "associations" do
    #it { should have_many(:user_communitys) }
    #it { should have_many(:users).through(:user_communitys) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { community.save; should validate_uniqueness_of(:name).case_insensitive }
    it { community.save; should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'seed' do
    # it "should seed communitys" do
    #   Badge.seed
    #   count = Badge.all.count
    #   expect(count).to be >= 2

    #   Badge.seed
    #   new_count = Badge.all.count
    #   expect(count).to eq new_count
    # end
  end

  describe "search" do
    it "should search_by_name" do
      community.name = "Developers"
      community.save

      results = Community.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq community    
    end

    it "should search_by_exact_name" do
      community.name = "Developers"
      community.save

      results = Community.search_by_exact_name('Developers')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq community      
    end
  end
end
