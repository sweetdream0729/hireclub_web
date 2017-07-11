class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.citext :name, null: false
      t.citext :slug, null: false
      t.string :avatar_uid
      t.text :description

      t.timestamps
    end

    add_index :communities, :name, unique: true
    add_index :communities, :slug, unique: true
  end
end
