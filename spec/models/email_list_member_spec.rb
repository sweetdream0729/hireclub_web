require 'rails_helper'

RSpec.describe EmailListMember, type: :model do
  let(:email_list_member) { FactoryGirl.build(:email_list_member) }

  subject { email_list_member }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:email_list_id).case_insensitive }
    it { should validate_uniqueness_of(:user_id).scoped_to(:email_list_id) }
  end
end
