require 'rails_helper'

RSpec.describe Placement, type: :model do
  let(:placement) { FactoryGirl.build(:placement) }

  subject { placement }

  describe "associations" do
    it { should belong_to(:placeable) }
    
  end

  describe 'validations' do
    it { should validate_presence_of(:placeable) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it "should validate that end time is after start_time" do
    	placement.end_time = placement.start_time - 1.minute
    	expect(placement).to be_invalid

    	placement.end_time = placement.start_time + 1.minute
    	expect(placement).to be_valid
    end
  end


  describe 'tags' do 
    it "should let you add tags" do
      placement.tags_list = "foo, bar"
      placement.save

      expect(placement).to be_valid
      expect(placement.tags[0]).to eq "foo"
      expect(placement.tags[1]).to eq "bar"      
    end 
  end

  describe "scopes" do
  	it "should sort placements by lowest priority first" do
  		placement1 = FactoryGirl.create(:placement, priority: 1)
			placement2 = FactoryGirl.create(:placement, priority: 2)
			placement3 = FactoryGirl.create(:placement, priority: 3)

			placements = Placement.by_priority

			expect(placements[0]).to eq placement1
			expect(placements[1]).to eq placement2
			expect(placements[2]).to eq placement3
  	end

    it "should get placements in_time" do
      now = DateTime.now
      placement1 = FactoryGirl.create(:placement, start_time: now + 1.hour, end_time: now + 4.hours)
      placement2 = FactoryGirl.create(:placement, start_time: now + 5.hours, end_time: now + 6.hours)

      placements = Placement.in_time(now + 2.hours)
      expect(placements[0]).to eq placement1
      expect(placements.count).to eq 1

      placements = Placement.in_time(now + 5.hours)
      expect(placements[0]).to eq placement2
      expect(placements.count).to eq 1
    end
  end

end
