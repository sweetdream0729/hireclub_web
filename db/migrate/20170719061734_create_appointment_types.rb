class CreateAppointmentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_types do |t|
      t.string :name, null: false
      t.text :description
      t.integer :duration, default: 0
      t.integer :price_cents, default: 0
      t.string :acuity_id, null: false
      t.references :appointment_category, foreign_key: true

      t.timestamps
    end

    add_index :appointment_types, :name, unique: true
    add_index :appointment_types, :acuity_id, unique: true
  end
end
