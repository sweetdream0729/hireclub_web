class AddIndexToAppointmentReview < ActiveRecord::Migration[5.0]
  def change
  	add_index :appointment_reviews, [:user_id, :appointment_id], unique: true
  end
end
