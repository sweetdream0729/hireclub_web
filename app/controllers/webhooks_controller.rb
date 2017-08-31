class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sparkpost
    #Rails.logger.info params.inspect

    params[:_json].each do |item|
      if item["msys"] && item["msys"]["message_event"]
        Rails.logger.info item.inspect
        SparkpostService.create_from_sparkpost_message_event(item["msys"]["message_event"])
      end
    end
  end

  #when appointment is scheduled
  def acuity_scheduled
    appointment_json = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    AcuityService.create_appointment(appointment_json)
  end

  #When appointment is rescheduled
  def acuity_rescheduled
    appointment_json = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    appointment = Appointment.find_by(acuity_id: appointment_json['id'])
    appointment.reschedule!(appointment_json['date'] + " " + appointment_json['time'], appointment_json['date'] + " " + appointment_json['endTime'])
  end

  #when appointment is cancelled
  def acuity_canceled
    appointment = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    a = Appointment.find_by(acuity_id: appointment['id'])
    a.cancel!
  end
  
end