class CreateAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :assignees do |t|
      t.references :appointment, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
