require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }
  let(:appointment) { FactoryGirl.build(:appointment) }

  subject { appointment }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:payee) }
    it { should belong_to(:completed_by) }
    it { should belong_to(:appointment_type) }
    it { should have_many(:appointment_messages) }
    it { should have_many(:participants).through(:appointment_messages) }
    it { should have_one(:appointment_review) }
    it { should have_many(:attachments) }
    it { should have_many(:payments) }
    it { should have_many(:payouts) }

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

  describe "activity" do
    it "should have create" do
      appointment.save

      activity = Activity.where(key: AppointmentCreateActivity::KEY).last
      expect(activity).to be_present

      expect(activity.trackable).to eq appointment
      expect(activity.owner).to eq appointment.user
      expect(activity.private).to eq true
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
    let(:appointment_category) { FactoryGirl.build(:appointment_category) }
    let(:appointment_type) { FactoryGirl.build(:appointment_type) }
    let(:appointment1) { FactoryGirl.build(:appointment) }
    let(:appointment2) { FactoryGirl.build(:appointment) }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.build(:admin) }

    it "should search by user name" do
      appointment_type.appointment_category_id = appointment_category.id
      appointment_type.save
      appointment_type.reload

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

    it "should search by appointment_type" do
      appointment_type.appointment_category_id = appointment_category.id
      appointment_type.save
      appointment_type.reload

      appointment1.user_id = user1.id
      appointment1.appointment_type_id = appointment_type.id
      appointment1.save

      results = Appointment.text_search(appointment_type.name)
      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first.appointment_type.name).to eq appointment_type.name
    end

    it "should search by appointment_category" do
      appointment_category.name = "testname"
      appointment_category.save
      appointment_category.reload

      appointment_type.appointment_category_id = appointment_category.id
      appointment_type.save
      appointment_type.reload

      appointment1.user_id = user1.id
      appointment1.appointment_type_id = appointment_type.id
      appointment1.save

      results = Appointment.text_search(appointment_category.name)
      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first.appointment_category.name).to eq appointment_category.name
    end
  end

  describe "assignees_count" do
    it "should cache assignees_count on appointment" do
      assignee = FactoryGirl.create(:assignee, appointment: appointment)
      appointment.reload

      expect(appointment.assignees_count).to eq 1

      assignee.destroy
      appointment.reload      

      expect(appointment.assignees_count).to eq 0
    end
  end

  describe "payments" do
    it "should update_payments" do
      appointment.acuity_id = "115819905"
      appointment.update_payments
    end
  end

  describe "payout" do
    it "should create payout" do
      StripeMock.toggle_debug(true)
      payee = FactoryGirl.create(:user)
      provider = FactoryGirl.create(:provider, user: payee)
      appointment.payee = payee
      appointment.save
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984)
      stripe_charge = Stripe::Charge.create(
        :amount => appointment.price_cents,
        :currency => "usd",
        :source => card_token
      )
      payment = Payment.create_from_stripe_charge(stripe_charge)
      payout = appointment.payout!

      expect(payout).to be_valid
      expect(payout.transferred_on).to be_present

    end
  end
  


end
