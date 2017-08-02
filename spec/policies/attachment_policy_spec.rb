require 'rails_helper'

RSpec.describe AttachmentPolicy do

  subject { AttachmentPolicy.new(user, attachment) }
  let(:scheduler) { FactoryGirl.create(:user) }
  let(:appointment) { FactoryGirl.create(:appointment,user: scheduler) }
  let(:provider) { FactoryGirl.create(:user) }
  let(:assignee) { FactoryGirl.create(:assignee, user:
    provider,appointment: appointment) }
  let(:attachment) { FactoryGirl.create(:attachment,user: scheduler,attachable: appointment) }


  context 'being a visitor' do
    let(:user) { nil }

    it { should forbid_action(:create) }
    it { should forbid_action(:destroy) }
  end

  context 'being a user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should forbid_action(:create) }
    it { should forbid_action(:destroy) }
  end

  context 'being a subscriber' do
    let(:user){appointment.user}
    it { should permit_action(:create) }
    it { should permit_action(:destroy) }
  end

  context 'being a provider' do
   let(:user){assignee.user}

    it { should permit_action(:create) }
    it { should forbid_action(:destroy) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.create(:admin) }

    it { should permit_action(:create) }
    it { should permit_action(:destroy) }
  end

  
end
