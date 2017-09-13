class AddPublishedOnToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :published_on, :datetime
    add_index :events, :published_on
  end
end
