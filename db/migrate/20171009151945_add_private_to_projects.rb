class AddPrivateToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :private, :boolean, default: false, null: false
    add_index :projects, :private
  end
end
