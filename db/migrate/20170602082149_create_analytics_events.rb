class CreateAnalyticsEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :analytics_events do |t|
      t.string :event_id, null: false
      t.citext :key, null: false
      t.jsonb :data, null: false, default: {}
      t.datetime :timestamp, null: false

      t.timestamps
    end
    add_index :analytics_events, :event_id, unique: true
    add_index :analytics_events, :key
    add_index :analytics_events, :timestamp
  end
end
