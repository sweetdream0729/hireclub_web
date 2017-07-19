class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.references :user, foreign_key: true
      t.string :acuity_id, null: false
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.integer :price_cents, default: 0
      t.integer :amount_paid_cents, default: 0
      t.references :appointment_type, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :timezone

      t.timestamps
    end

    add_index :appointments, :acuity_id, unique: true
    add_index :appointments, :start_time
    add_index :appointments, :end_time
  end
end
