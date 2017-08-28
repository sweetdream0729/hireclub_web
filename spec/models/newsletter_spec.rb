require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  
  let(:newsletter) { FactoryGirl.build(:newsletter) }

  subject { newsletter }

  describe "associations" do
    
  end

  describe 'validations' do
    it { should validate_presence_of(:subject) }
    it { newsletter.save; should validate_uniqueness_of(:campaign_id).allow_nil }
  end

  describe "name" do
    it "should have a name based on sent_on" do
      newsletter.sent_on = DateTime.now

      expect(newsletter.set_name).to eq("Newsletter #{newsletter.sent_on.strftime('%D %I:%M %p')}")
      expect(newsletter.set_campaign_id).to eq(newsletter.name.parameterize.gsub("-","_").downcase)
    end 
  end
end
