require 'rails_helper'

RSpec.describe Skill, type: :model do
  let(:skill) { FactoryGirl.create(:skill) }

  subject { skill }

  describe "associations" do
    # it { should have_many(:authentications) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }

  end

end