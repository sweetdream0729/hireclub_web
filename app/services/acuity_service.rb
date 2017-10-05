class AcuityService
  BASE_URL = "https://acuityscheduling.com"
  
  def self.get_client
    @connection ||=  Excon.new( BASE_URL, 
                                user: Rails.application.secrets.acuity_user_id, 
                                password: Rails.application.secrets.acuity_api_key,
                                debug_response: true)

    # @connection ||= Excon.new("https://13980751:ebf8d901f44bf9a786cc266474087469@acuityscheduling.com")
  end

  def self.get_appointment_types
    JSON.parse(self.get_client.get(path:"/api/v1/appointment-types").body) rescue []
  end


  def self.get_appointments
    JSON.parse(self.get_client.get(path:"/api/v1/appointments").body) rescue []
  end

  def self.get_appointment(acuity_id)
    JSON.parse(self.get_client.get(path:"/api/v1/appointments/#{acuity_id}").body) rescue []
  end

  def self.get_payments(acuity_id)
    puts "get_payments #{acuity_id}"
    JSON.parse(self.get_client.get(path:"/api/v1/appointments/#{acuity_id}/payments").body) rescue []
  end

  def self.refresh_appointment_types
    acuity_options = AcuityService.get_appointment_types
    appointment_types = []

    acuity_options.each do |acuity_option|
      appointment_category = AppointmentCategory.where(name: acuity_option["category"]).first_or_create
      appointment_type_options = { name: acuity_option["name"], 
                       description: acuity_option["description"], 
                       duration: acuity_option["duration"], 
                       price: acuity_option["price"], 
                       appointment_category_id: appointment_category.id }
      appointment_type = AppointmentType.where(acuity_id: acuity_option["id"]).first_or_create(appointment_type_options)
      appointment_types << appointment_type
    end
    return appointment_types
  end

  def self.refresh_appointments
    appointments = AcuityService.get_appointments

    appointments.each do |appointment|
      self.create_appointment(appointment)
    end
  end

  def self.create_appointment(appointment)
    Rails.logger.info "create_appointment #{appointment.inspect}"
    user = User.find_by(email: appointment['email'])
    appointment_type = AppointmentType.find_by(acuity_id: appointment['appointmentTypeID'])
    
    a = Appointment.where(acuity_id: appointment['id']).first_or_initialize

    a.first_name = appointment['firstName']
    a.last_name = appointment['lastName']
    a.phone = appointment['phone']
    a.email = appointment['email']
    a.price = appointment['price']
    a.amount_paid = appointment['amountPaid']

    timezone = appointment['timezone']
    a.timezone = timezone

    a.start_time = (appointment['date'] + " " + appointment['time']).in_time_zone(a.timezone)
    a.end_time = (appointment['date'] + " " + appointment['endTime']).in_time_zone(a.timezone)
    
    a.confirmation_page_url = appointment['confirmationPage']
    a.acuity_calendar_id = appointment['calendarID']

    #if user is not registered on hireclub
    a.user_id = user.id if a.user.nil? && user.present?
    a.appointment_type_id = appointment_type.id if appointment_type.present?
    a.save

    #if no assignee present and calendar id exist assign provider as helper
    if a.assignees.empty?
      provider = Provider.find_by(acuity_calendar_id: a.acuity_calendar_id)
      if provider.present?
        assignee = a.assignees.where(user_id: provider.user_id).first_or_create
      end
    end
  end


  def self.refresh
    self.refresh_appointment_types
    self.refresh_appointments
  end
end