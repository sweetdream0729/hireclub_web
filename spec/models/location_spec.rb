require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) { FactoryGirl.create(:location) }

  subject { location }

  describe "associations" do
    it { should belong_to(:parent) }
    it { should have_many(:children) }
    it { should have_many(:users) }
    # it { should have_many(:users).through(:user_locations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:parent_id).case_insensitive}

    it { should validate_inclusion_of(:level).in_array(Location::VALID_LEVELS) }    
  end

  describe "slugs" do
    it "should create slug based on name and state code" do
      california = FactoryGirl.create(:location, name: 'California', level: Location::STATE, short: 'CA')
      location.parent = california
      location.name = "San Francisco"
      location.save

      expect(location.slug).to eq "san-francisco-ca"
    end
  end

  describe "root" do
    it "should have a root" do
      root = Location.create_root
      expect(root.name).to eq "Anywhere"
      expect(root.level).to eq Location::ROOT
    end
  end

  describe "imports" do
    it "should import countries" do
      Location.import_countries

      countries = Location.where(level: Location::COUNTRY)
      countries.count.should > 1

      usa = Location.where(short:'US', level: Location::COUNTRY).first
      expect(usa).to be_present
    end

    it "should import states" do
      Location.import_states

      states = Location.where(level: Location::STATE)
      states.count.should > 1

      california = Location.where(name:'California', level: Location::STATE).first
      expect(california.short).to eq "CA"
      expect(california.parent).to eq Location.where(short:'US', level: Location::COUNTRY).first

    end

    it "should import cities" do

      Location.import_cities

      la = Location.where(name:'Los Angeles').first
      expect(la).to be_present
      expect(la.parent.name).to eq "California"

      sf = Location.where(name:'San Francisco').first
      expect(sf).to be_present
      expect(sf.parent.name).to eq "California"
    end
  end

  describe "search" do
    it "should search_by_name" do
      location.name = "Developer"
      location.save

      results = Location.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq location      
    end

    it "should search_by_exact_name" do
      location.name = "Developer"
      location.save

      results = Location.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq location      
    end
  end

  describe "users_count" do
    let(:user) { FactoryGirl.create(:user) }
    it "should cache users count" do
      user.location = location
      user.save

      location.reload
      expect(location.users_count).to eq 1
    end
  end

end