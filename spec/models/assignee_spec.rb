require 'rails_helper'

RSpec.describe Assignee, type: :model do
	
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:appointment) }
  end
end
