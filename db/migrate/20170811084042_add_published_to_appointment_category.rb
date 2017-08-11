class AddPublishedToAppointmentCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_categories, :published, :boolean, null: false, default: true
    add_index  :appointment_categories, :published
  end
end
