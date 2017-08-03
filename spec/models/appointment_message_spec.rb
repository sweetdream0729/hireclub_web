require 'rails_helper'

RSpec.describe AppointmentMessage, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:appointment) { FactoryGirl.create(:appointment, user: user) }
  let(:appointment_message) { FactoryGirl.build(:appointment_message, user: user, appointment: appointment) }

  subject { appointment_message }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:appointment) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end

  describe "activity" do
    let(:user2) { FactoryGirl.create(:user) }

    it "should have create activity" do
      appointment_message = FactoryGirl.create(:appointment_message, user: user2, appointment: appointment)

      activity = Activity.where(key: AppointmentMessageCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(appointment_message)
      expect(activity.owner).to eq(appointment_message.user)
      expect(activity.private).to eq(true)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      notification = notifications.first
      expect(notification.user).to eq appointment.user
    end

    it "should have edit activity" do
      appointment_message = FactoryGirl.create(:appointment_message, user: user2, appointment: appointment)
      old_text = appointment_message.text
      appointment_message.text = "Hi"
      appointment_message.save
      activity = appointment_message.activities.where(key: "appointment_message.edit").first
      expect(activity).to be_present
      expect(activity.trackable).to eq(appointment_message)
      expect(activity.owner).to eq(appointment_message.user)
      expect(activity.parameters[:old_text]).to eq(old_text)
      expect(activity.private).to eq(true)
    end
  end
end
