class AddTimezoneToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :timezone, :string
  end
end
