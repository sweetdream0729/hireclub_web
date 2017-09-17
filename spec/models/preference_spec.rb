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

  describe "unsubscribe_all" do
    it "should unsubscribe to all notifications" do
      preference.unsubscribe_all = true
      preference.save

      expect(preference.email_on_follow).to be false
      expect(preference.email_on_comment).to be false
      expect(preference.email_on_mention).to be false
    end
  end

  describe "self.get_label" do
    it "should return correct label for preference" do
      expect(Preference.get_label("unsubscribe_all")).to eq("all")
      expect(Preference.get_label("email_newsletter")).to eq("newsletter")
      expect(Preference.get_label("email_on_follow")).to eq("follow")
      expect(Preference.get_label("email_on_comment")).to eq("comment")
      expect(Preference.get_label("email_on_mention")).to eq("mention")
    end
  end
end
