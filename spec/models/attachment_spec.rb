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
      attachment.save
      expect(attachment).not_to be_valid

      attachment.link = "http://instagram.com/attachmentname"
      attachment.save
      expect(attachment).to be_valid

      attachment.link = nil
      attachment.file_uid = "test"
      attachment.save

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

    it "should ignore invalid urls" do
      attachment.link = "foo"
      expect(attachment.link).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/attachmentname").for(:link) }
  end
end
