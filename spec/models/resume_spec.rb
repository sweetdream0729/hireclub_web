require 'rails_helper'

RSpec.describe Resume, type: :model do
  let(:resume) { FactoryGirl.build(:resume) }
  
  subject { resume }

  describe "associations" do
    it { should belong_to(:user) }
    it { should respond_to(:file) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:file) }
  end
end
