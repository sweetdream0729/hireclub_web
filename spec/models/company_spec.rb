require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { FactoryGirl.create(:company) }

  subject { company }

  describe "associations" do
    it { should respond_to(:avatar) }
    it { should respond_to(:logo) }
    # it { should have_many(:user_companys) }
    # it { should have_many(:users).through(:user_companys) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }

    it { is_expected.to allow_value("http://kidbombay.com", "https://kidbombay.com").for(:website_url) }
    it { is_expected.not_to allow_value("kidbombay.com", "foo").for(:website_url) }
  end

  describe 'seed' do
    # it "should seed companys" do
    #   Company.seed

    #   expect(Company.all.count).to be >= 5
    # end
  end

  describe "search" do
    it "should search_by_name" do
      company.name = "HireClub"
      company.save

      results = Company.search_by_name('hire')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq company    
    end

    it "should search_by_exact_name" do
      company.name = "HireClub"
      company.save

      results = Company.search_by_exact_name('HireClub')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq company      
    end
  end

end