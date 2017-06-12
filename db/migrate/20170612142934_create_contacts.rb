class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :email, null: false

      t.timestamps
    end

    add_index :contacts, [:email], :unique => true
  end
end
