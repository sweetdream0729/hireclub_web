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

  describe "domain" do
    it "should get domain from website_url" do
      company.website_url = "https://hireclub.co"
      expect(company.domain).to eq("hireclub.co")
    end
  end

  describe "imports" do
    it "should import companies from companies.json",focus: true do
      Company.destroy_all

      json = Company.import
      expect(json).to be_present

      companies = Company.all
      expect(companies.count).to be > 0

      hireclub = companies.first

      expect(hireclub).to be_present
      expect(hireclub).to be_persisted
      expect(hireclub.name).to eq "HireClub"
      expect(hireclub.slug).to eq "hireclub"
      expect(hireclub.twitter_url).to eq "https://twitter.com/hireclub"
      expect(hireclub.website_url).to eq "http://hireclub.co"
      expect(hireclub.facebook_url).to eq "https://facebook.com/hireclub"
      expect(hireclub.tagline).to eq "Invite only job referrals."      
    end
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