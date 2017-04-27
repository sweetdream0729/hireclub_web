require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build(:comment) }

  subject { comment }

  describe "associations" do
    it { should belong_to(:user)}
    it { should belong_to(:commentable)}
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:commentable) }
    it { should validate_presence_of(:text) }
  end
end
