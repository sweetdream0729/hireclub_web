require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:appointment) { FactoryGirl.build(:appointment) }

  subject { appointment }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:completed_by) }
    it { should belong_to(:appointment_type) }
    it { should have_many(:appointment_messages) }
    it { should have_many(:participants).through(:appointment_messages) }
    it { should have_one(:appointment_review) }
  end

  describe 'validations' do
    it { should validate_presence_of(:acuity_id) }
    it { appointment.save; should validate_uniqueness_of(:acuity_id) }
  end

  describe 'cancel' do
    it "should cancel!" do
      appointment.cancel!

      expect(appointment.canceled_at).not_to be_nil
      expect(appointment.canceled?).to eq true
      expect(appointment.active?).to eq false
      expect(appointment.status).to eq "Canceled"
    end
  end

  describe "reschedule!" do
    it "should reschedule!" do
      new_start_time = DateTime.now + 1.day
      new_end_time = new_start_time + 1.hour
      appointment.reschedule!(new_start_time, new_end_time)

      appointment.reload

      expect(appointment.start_time).to eq new_start_time
      expect(appointment.end_time).to eq new_end_time
    end
  end

  describe "complete!" do
    let(:completer) { FactoryGirl.build(:user) }
    it "should complete!" do
      appointment.complete!(completer)

      appointment.reload

      expect(appointment.completed_on).not_to be_nil
      expect(appointment.completed_by).to eq completer

      activity = Activity.where(key: AppointmentCompleteActivity::KEY).last
      expect(activity).to be_present

      expect(activity.owner).to eq completer
      expect(activity.private).to eq true
      expect(activity.recipient).to eq appointment.user

    end
  end

  describe "search" do
    it "should search in order user, category, assigned" do
      appointment_type = FactoryGirl.create(:appointment_type)
      appointment1 = FactoryGirl.build(:appointment)
      appointment2 = FactoryGirl.build(:appointment)
      
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.build(:admin)
      user2.name = "Developer"
      user2.save

      appointment1.user_id = user1.id
      appointment1.appointment_type_id = appointment_type.id
      appointment1.save

      appointment2.user_id = user2.id
      appointment2.appointment_type_id = appointment_type.id
      appointment2.acuity_id = "MyString2"
      appointment2.save
      #assigning the appointment to user1
      appointment1.assignees.create(user_id: user2.id)

      results = Appointment.text_search(user2.name)

      expect(results).not_to be_nil
      expect(results.count).to eq 2
      expect(results.first.user.name).to eq user2.name
      #check the precedence in result
      expect(results.first.assigned_users.count).to eq 0
      expect(results.last.assigned_users.first.name).to eq user2.name
    end
  end
end
