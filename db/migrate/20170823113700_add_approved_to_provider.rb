class AddApprovedToProvider < ActiveRecord::Migration[5.0]
  def change
    add_column :providers, :approved, :boolean, default: false, null: false
    add_index :providers, :approved
  end
end
