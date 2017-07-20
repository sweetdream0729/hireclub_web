class CreateAppointmentTypeProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_type_providers do |t|
      t.references :user, foreign_key: true
      t.references :appointment_type, foreign_key: true

      t.timestamps
    end
  end
end
