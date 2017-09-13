class CreateEmailListMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :email_list_members do |t|
      t.string :email, null: false
      t.references :user, foreign_key: true
      t.references :email_list, foreign_key: true, null: false

      t.timestamps
    end

    add_index :email_list_members, [:email, :email_list_id], unique: true
    add_index :email_list_members, [:user_id, :email_list_id], unique: true
  end
end
