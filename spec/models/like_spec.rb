require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { FactoryGirl.create(:like) }

  subject { like }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likeable_id) }
    it { should validate_presence_of(:likeable_type) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:likeable_id, :likeable_type]).case_insensitive }
  end

  describe 'counter_cache' do
    it "should cache likes_count on likeable" do
      expect(like.likeable.likes_count).to eq(1)

      like.destroy
    
      expect(like.likeable.likes_count).to eq(0)      
    end
  end
end
