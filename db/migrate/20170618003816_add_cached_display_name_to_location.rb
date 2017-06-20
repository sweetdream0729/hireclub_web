class AddCachedDisplayNameToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :cached_display_name, :string

    Location.all.map(&:save)
  end
end
