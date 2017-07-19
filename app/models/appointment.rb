class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :appointment_type

  def self.refresh_appointments
  	appointments = AcuityService.get_appointments

  	appointments.each do |appointment|
  		user = User.find_by(email: appointment['email'])
  		appointment_type = AppointmentType.find_by(name: appointment['type'])
  		a = self.where(acuity_id: appointment['id']).first_or_create(
  			first_name: appointment['firstName'],
  			last_name: appointment['lastName'],
  			phone: appointment['phone'],
  			email: appointment['email'],
  			price_cents: appointment['price'],
  			amount_paid_cents: appointment['amountPaid'],
  			start_time: appointment['date'] + " " + appointment['time'],
  			end_time: appointment['date'] + " " + appointment['endTime'],
  			timezone: appointment['timezone']
  		)

  		#if user is not registered on hireclub
  		a.user_id = user.id if !user.nil?
  		a.appointment_type_id = appointment_type.id if !appointment_type.nil?
  		a.save
  	end
  end
end
