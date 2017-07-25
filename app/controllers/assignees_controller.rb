class AssigneesController < ApplicationController

	def create
		@appointment = Appointment.find(params[:assignee][:appointment_id])
		old_count = @appointment.assignees.count
		params[:users].each do |user_id|
			assignee = @appointment.assignees.where(user_id: user_id).first_or_create
		end
		@assignees = @appointment.assignees
		
		new_count = @assignees.count
		@count = new_count - old_count
	end
end