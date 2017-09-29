class AddPublishedToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :published, :boolean, default: true, null: false

    add_index :milestones, :published
  end
end
