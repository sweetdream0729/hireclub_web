require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:attachment) { FactoryGirl.build(:attachment) }

  subject { attachment }

  describe "associations" do
    it { should belong_to(:attachable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:attachable) }

    it "should be invalid without link or file" do
      attachment.link = nil
      attachment.file_uid = nil
      expect(attachment).not_to be_valid
    end

    it "should be valid with link" do
      attachment.link = "http://instagram.com/attachmentname"
      expect(attachment).to be_valid
    end

    it "should be valid with file" do
      attachment.link = nil
      attachment.file_uid = "test"
      expect(attachment).to be_valid
    end

  end

  describe "link" do
    it "should add http if missing" do
      attachment.link = "instagram.com/attachmentname"
      expect(attachment.link).to eq("http://instagram.com/attachmentname")
    end

    it "should add http if missing ignoring subdomains" do
      attachment.link = "www.instagram.com/attachmentname"
      expect(attachment.link).to eq("http://www.instagram.com/attachmentname")
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/attachmentname").for(:link) }
  end

  describe "activity" do
    it "should have create activity" do
      attachment.save
      activity = Activity.where(key: AttachmentCreateActivity::KEY).last
      expect(activity).to be_present

      expect(activity.trackable).to eq attachment
      expect(activity.private).to eq true
    end
  end
end
