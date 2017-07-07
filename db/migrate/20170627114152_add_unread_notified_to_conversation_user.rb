class AddUnreadNotifiedToConversationUser < ActiveRecord::Migration[5.0]
  def change
    add_column :conversation_users, :unread_notified, :boolean, default: false, null: false

    add_index :conversation_users, :unread_notified
  end
end
