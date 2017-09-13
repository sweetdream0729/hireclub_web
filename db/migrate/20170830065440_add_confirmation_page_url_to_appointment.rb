class AddConfirmationPageUrlToAppointment < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointments, :confirmation_page_url, :text
  end
end
