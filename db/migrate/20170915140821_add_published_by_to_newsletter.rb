class AddPublishedByToNewsletter < ActiveRecord::Migration[5.0]
  def change
    add_column :newsletters, :published_by_id, :integer
  end
end
