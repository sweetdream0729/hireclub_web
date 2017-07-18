class AddLatitudeLongitudeToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float

    Location.all.find_each do |l|
      l.save
    end
  end
end
