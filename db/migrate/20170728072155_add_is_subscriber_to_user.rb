class AddIsSubscriberToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :is_subscriber, :boolean, default: false, null: false
    add_index  :users, :is_subscriber
  end
end
