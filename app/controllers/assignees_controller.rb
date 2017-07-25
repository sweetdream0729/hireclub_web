class AssigneesController < ApplicationController

	def create
		@appointment = Appointment.find(params[:assignee][:appointment_id])
		params[:users].each do |user_id|
			a = @appointment.assignees.create(user_id: user_id)
		end
		@assignees = @appointment.assignees
	end
end