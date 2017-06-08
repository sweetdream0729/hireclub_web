class CreatePlacements < ActiveRecord::Migration[5.0]
  def change
    create_table :placements do |t|
      t.references :placeable, polymorphic: true, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :priority, null: false, default: 0
      t.timestamps
    end

    add_column :placements, :tags, :string, array: true, default: []
    add_index  :placements, :tags, using: 'gin'  

    add_index  :placements, :start_time
    add_index  :placements, :end_time
  end
end
