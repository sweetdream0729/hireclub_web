class AddImageToAppointmentType < ActiveRecord::Migration[5.0]
  def change
    add_column :appointment_types, :image_uid, :string
  end
end
