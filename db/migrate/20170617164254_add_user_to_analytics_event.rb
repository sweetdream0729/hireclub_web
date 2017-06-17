class AddUserToAnalyticsEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :analytics_events, :user, foreign_key: true
  end
end
