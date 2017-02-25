require 'rails_helper'

RSpec.describe Activity, :type => :model do
  let(:activity) { FactoryGirl.build(:activity) }

  subject { activity }

  describe "associations" do
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end
end