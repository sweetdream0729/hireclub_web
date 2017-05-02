require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { FactoryGirl.build(:job) }

  subject { job }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:description) }
    
    #it { should validate_uniqueness_of(:slug).case_insensitive }
    
  end

  describe "link" do
    it "should add http if missing" do
      job.link = "instagram.com/username"
      expect(job.link).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      job.link = "www.instagram.com/username"
      expect(job.link).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      job.link = "foo"
      expect(job.link).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:link) }
  end



  # describe 'tags' do 
  #   it "should let you add tags" do
  #     company.tags_list = "foo, bar"
  #     company.save

  #     expect(company).to be_valid
  #     expect(company.tags[0]).to eq "foo"
  #     expect(company.tags[1]).to eq "bar"      
  #   end 
  # end



end
