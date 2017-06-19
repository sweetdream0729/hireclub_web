require 'rails_helper'

RSpec.describe Preference, type: :model do
  let(:preference) { FactoryGirl.build(:preference) }

  subject { preference }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { preference.save; should validate_uniqueness_of(:user) }
  end
end
