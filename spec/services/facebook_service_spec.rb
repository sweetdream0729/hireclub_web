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

  it "should search facebook pages" do
    expect(kidbombay_auth).to be_valid

    results = FacebookService.search_pages("visa")
    expect(results).to be_present

    first = results.first
    expect(first["name"]).to eq "Visa"
    expect(first["id"]).to eq "211718455520845"
    expect(first["link"]).to eq "https://www.facebook.com/VisaUnitedStates/"
  end



end
