require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { FactoryGirl.build(:contact) }  

  subject { contact }

  context "associations" do
    it { should have_many(:invites) }
  end

  context "validations" do
    it { should validate_presence_of(:email) }
    it { contact.save; is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@test.com').for(:email) }
    it { should allow_value('info+test@company.co').for(:email) }
    it { should_not allow_value('company.co').for(:email) }
    it { should_not allow_value('foo').for(:email) }
  end



end
