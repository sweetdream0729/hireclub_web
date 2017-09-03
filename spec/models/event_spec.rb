require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryGirl.build(:event) }

  subject { event }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:location) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    #it { should validate_presence_of(:slug) }
    it { event.save; should validate_uniqueness_of(:slug).case_insensitive }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:source_url) }
    it { should validate_presence_of(:location) }

  end

  describe "source_url" do
    it "should add http if missing" do
      event.source_url = "instagram.com/username"
      expect(event.source_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      event.source_url = "www.instagram.com/username"
      expect(event.source_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      event.source_url = "foo"
      expect(event.source_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:source_url) }
  end
end
