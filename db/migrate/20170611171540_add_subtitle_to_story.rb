class AddSubtitleToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :subtitle, :string
  end
end
