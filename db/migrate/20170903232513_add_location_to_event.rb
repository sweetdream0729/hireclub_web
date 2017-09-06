class AddLocationToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :location, foreign_key: true
  end
end
