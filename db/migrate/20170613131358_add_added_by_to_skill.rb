class AddAddedByToSkill < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :added_by_id, :integer
    add_index :skills, :added_by_id
  end
end
