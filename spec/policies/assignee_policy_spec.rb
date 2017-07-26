require 'rails_helper'

RSpec.describe AssigneePolicy do

  subject { AssigneePolicy.new(user, assignee) }
  let(:scheduler) { FactoryGirl.create(:user) }
  let(:appointment) { FactoryGirl.create(:appointment,user: scheduler) }
  let(:provider) { FactoryGirl.create(:user) }
  let(:assignee) { FactoryGirl.create(:assignee, user:
    provider,appointment: appointment) }

  context 'being a visitor' do
    let(:user) { nil }

    it { should forbid_action(:create) }
    it { should forbid_action(:assign_me) }
  end

  context 'being a user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should forbid_action(:create) }
    it { should forbid_action(:assign_me) }
  end

  context 'being a subscriber' do
    let(:user){appointment.user}
    it { should forbid_action(:create) }
    it { should forbid_action(:assign_me) }
  end

  context 'being a provider' do
   let(:user){assignee.user}

    it { should permit_action(:create) }
    it { should permit_action(:assign_me) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.create(:admin) }

    it { should permit_action(:create) }
    it { should permit_action(:assign_me) }
  end

end
