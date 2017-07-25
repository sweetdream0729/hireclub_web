class AssigneesController < ApplicationController

	def create
		@appointment = Appointment.find(params[:assignee][:appointment_id])
		params[:users].each do |user_id|
			assignee = @appointment.assignees.where(user_id: user_id).first_or_create
		end
		@assignees = @appointment.assignees
	end
end