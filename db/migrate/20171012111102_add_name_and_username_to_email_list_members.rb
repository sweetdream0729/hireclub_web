class AddNameAndUsernameToEmailListMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :email_list_members, :name, :string
    add_column :email_list_members, :username, :string
  end
end
