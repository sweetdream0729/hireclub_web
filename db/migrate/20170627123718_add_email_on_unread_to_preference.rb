class AddEmailOnUnreadToPreference < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :email_on_unread, :boolean, null: false, default: true

    add_index :preferences, :email_on_unread
  end
end
