require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:conversation) { FactoryGirl.build(:conversation) }
  
  subject { conversation }

  describe "associations" do
    it { should have_many(:conversation_users).dependent(:destroy) }
    it { should have_many(:users).through(:conversation_users) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:slug) }
  end

 
end