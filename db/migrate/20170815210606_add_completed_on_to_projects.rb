class AddCompletedOnToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :completed_on, :date
    add_index :projects, :completed_on
  end
end
