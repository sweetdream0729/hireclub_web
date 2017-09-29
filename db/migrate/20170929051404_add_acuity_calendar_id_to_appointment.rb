class AddAcuityCalendarIdToAppointment < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointments, :acuity_calendar_id, :integer
  end
end
