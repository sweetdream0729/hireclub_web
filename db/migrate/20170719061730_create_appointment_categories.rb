class CreateAppointmentCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_categories do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.text :description
      t.string :image_uid

      t.timestamps
    end

    add_index :appointment_categories, :name, unique: true
    add_index :appointment_categories, :slug, unique: true
  end
end
