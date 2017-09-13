class CreateEmailLists < ActiveRecord::Migration[5.0]
  def change
    create_table :email_lists do |t|
      t.citext :name, null: false
      t.integer :members_count, null: false, default: 0
      t.timestamps
    end

    add_index :email_lists, :name, unique: true
  end
end
