class CreateAppointmentMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_messages do |t|
      t.references :user, foreign_key: true, null: false
      t.references :appointment, foreign_key: true, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
