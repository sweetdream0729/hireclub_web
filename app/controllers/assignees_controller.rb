class AssigneesController < ApplicationController
	after_action :verify_authorized, only: [:create, :assign_me]

	def create
		@flag = 0

		#when request is from the form
		if params.has_key?(:assignee) && params.has_key?(:users)
			@appointment = Appointment.find(params[:assignee][:appointment_id])
			params[:users].each do |user_id|
				assignee = @appointment.assignees.where(user_id: user_id).first_or_initialize
				authorize(assignee)
				assignee.save
			end
		else #when assign me link is clicked
			@appointment = Appointment.find(params[:appointment_id])
			assignee = @appointment.assignees.where(user_id: current_user.id).first_or_initialize
			authorize(assignee)
			assignee.save
			@flag = 1 #for removing assign me link
		end
		@assignees = @appointment.assignees
		
	end
end