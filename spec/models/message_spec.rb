require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { FactoryGirl.build(:message) }

  subject { message }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe 'validations' do
    it { should validate_presence_of(:conversation) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end

end
