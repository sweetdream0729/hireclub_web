class CreateAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :assignees do |t|
      t.references :appointment, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :assignees, [:user_id, :appointment_id], unique: true
  end
end
