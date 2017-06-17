module Admin::AnalyticsEventAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      list do
        scopes [nil, :searches, :email_clicks]
        
        field :id
        field :key
        field :user
        field :data
        field :timestamp
        field :event_id
        field :created_at
      end
    end
  end
end