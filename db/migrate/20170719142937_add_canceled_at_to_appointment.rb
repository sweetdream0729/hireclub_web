class AddCanceledAtToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :canceled_at, :datetime
  end
end
