require 'rails_helper'

RSpec.describe Assignee, type: :model do
	
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
  	it { should validate_presence_of(:user) }
    it { should validate_presence_of(:appointment) }
  end
end
