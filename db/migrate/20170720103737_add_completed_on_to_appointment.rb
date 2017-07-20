class AddCompletedOnToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :completed_on, :datetime
    add_reference :appointments, :completed_by, foreign_key: { to_table: :users }, index: true
  end
end
