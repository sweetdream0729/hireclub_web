class AddPublishedToAppointmentType < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_types, :published, :boolean, null: false, default: true
    add_index  :appointment_types, :published
  end
end
