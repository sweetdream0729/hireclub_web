class AssigneesController < ApplicationController
	after_action :verify_authorized, only: [:create, :destroy]

	def create
		@appointment = Appointment.find(params[:assignee][:appointment_id])
		params[:users].each do |user_id|
			assignee = @appointment.assignees.where(user_id: user_id).first_or_initialize
			authorize(assignee)
			assignee.save
		end
		@assignees = @appointment.assignees
		
	end

	def destroy
		@assignee = Assignee.find(params[:id])
		authorize @assignee
		@assignee.destroy
	end

end