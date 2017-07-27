require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # Mimic the router behavior of setting the Devise scope through the env.
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # Use the sign_in helper to sign in a fixture `User` record.
    sign_in(user)
  end

  describe "GET #index" do

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #status" do
    it "returns http success" do
      get :status
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #account" do
    it "returns http success" do
      get :account
      expect(response).to have_http_status(:success)
    end
  end

end
