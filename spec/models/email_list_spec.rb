require 'rails_helper'

RSpec.describe EmailList, type: :model do
  let(:email_list) { FactoryGirl.build(:email_list) }

  subject { email_list }

  describe 'associations' do
    it { is_expected.to have_many(:email_list_members).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:email_list_members) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end


  it "should create an All Users list if it doesn't exist" do
    all = EmailList.get_all_users
    expect(all).to be_valid
    expect(all.name).to eq('All Users')
  end

  describe "users" do
    it "should add user to a list" do
      user = FactoryGirl.create(:user)
      email_list.add_user(user)
      email_list.add_user(user)
      email_list.reload

      expect(email_list.members_count).to eq(1)
      member = email_list.email_list_members.first
      expect(member.user).to eq(user)
    end

    it "should add a confirmed user to all list" do
      user = FactoryGirl.create(:user)
      user.welcome!

      all = EmailList.get_all_users
      expect(all.members_count).to eq(1)
    end
  end
end
