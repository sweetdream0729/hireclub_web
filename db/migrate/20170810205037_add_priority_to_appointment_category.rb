class AddPriorityToAppointmentCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_categories, :priority, :integer, null: false, default: 0
  end
end
