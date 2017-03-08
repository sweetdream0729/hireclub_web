require 'rails_helper'

RSpec.describe ConversationUser, type: :model do
  let(:conversation_user) { FactoryGirl.build(:conversation_user) }
  
  subject { conversation_user }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to(:conversation_id) }
  end

 
end