class AddAcuityCalenderIdToProvider < ActiveRecord::Migration[5.0]
  def change
  	add_column :providers, :acuity_calendar_id, :integer
  end
end
