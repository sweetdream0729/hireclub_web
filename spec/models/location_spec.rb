require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) { FactoryGirl.create(:location) }

  subject { location }

  describe "associations" do
    it { should belong_to(:parent) }
    it { should have_many(:children) }
    # it { should have_many(:user_locations) }
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
      location.slug.should == "san-francisco-ca"
    end
  end

  describe "root" do
    it "should have a root" do
      root = Location.create_root
      root.name.should == "Anywhere"
      root.level.should == Location::ROOT
    end
  end

  describe "imports" do
    it "should import countries" do
      Location.import_countries

      countries = Location.where(level: Location::COUNTRY)
      countries.count.should > 1

      usa = Location.where(short:'US', level: Location::COUNTRY).first
      usa.should_not be_nil
    end

    it "should import states" do
      Location.import_states

      states = Location.where(level: Location::STATE)
      states.count.should > 1

      california = Location.where(name:'California', level: Location::STATE).first
      california.short.should == "CA"
      california.parent.should == Location.where(short:'US', level: Location::COUNTRY).first

    end

    it "should import cities" do

      Location.import_cities

      la = Location.where(name:'Los Angeles').first
      la.should_not be_nil
      la.parent.name.should == "California"

      sf = Location.where(name:'San Francisco').first
      sf.should_not be_nil
      sf.parent.name.should == "California"
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

end