class AddRelocationOfferedToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :relocation_offered, :boolean, default: false, null: false
    add_index :jobs, :relocation_offered
  end
end
