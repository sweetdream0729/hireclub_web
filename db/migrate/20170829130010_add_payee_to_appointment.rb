class AddPayeeToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :payee_id, :integer, foreign_key: true, index: true
  end
end
