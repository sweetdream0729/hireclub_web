class AddContactToInvite < ActiveRecord::Migration[5.0]
  def change
    add_reference :invites, :contact, foreign_key: true
  end
end
