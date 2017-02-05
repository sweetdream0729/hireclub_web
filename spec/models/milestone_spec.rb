require 'rails_helper'

RSpec.describe Milestone, type: :model do
  let(:milestone) { FactoryGirl.create(:milestone) }

  subject { milestone }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end



end