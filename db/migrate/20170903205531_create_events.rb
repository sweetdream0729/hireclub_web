class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.text :description
      t.string :source_url
      t.string :image_uid
      t.string :venue
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :events, :slug, unique: true
  end
end
