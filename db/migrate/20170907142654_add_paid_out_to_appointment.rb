class AddPaidOutToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :paid_out, :boolean, null: false, default: false
    add_index  :appointments, :paid_out
  end
end
