require 'rails_helper'

RSpec.describe ReviewRequest, type: :model do
  let(:review_request) { FactoryGirl.build(:review_request) }

  subject { review_request }

  describe "associations" do
    it { should belong_to(:user)}
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_length_of(:goal).is_at_least(10) }
  end
    
end
