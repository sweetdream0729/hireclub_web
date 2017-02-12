require 'rails_helper'

RSpec.describe FacebookService do
  let(:user)  { FactoryGirl.create(:user, username: 'kidbombay') }
  let(:kidbombay_auth) { FactoryGirl.create(:authentication, :kidbombay, user: user) }

  it "should create a facebook client" do
    expect(kidbombay_auth).to be_valid
    expect(user.has_facebook?).to eq(true)

    client = FacebookService.get_client
    expect(client).to be_present
    puts client
  end



end
