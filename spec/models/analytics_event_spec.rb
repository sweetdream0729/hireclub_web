require 'rails_helper'

RSpec.describe AnalyticsEvent, type: :model do
  let(:analytics_event) { FactoryGirl.build(:analytics_event) }

  subject { analytics_event }

  describe 'validations' do
    it { should validate_presence_of(:event_id) }
    it { should validate_uniqueness_of(:event_id) }

    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:timestamp) }
    
  end
end
