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
    appointment = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    AcuityService.create_appointment(appointment)
  end

  #When appointment is rescheduled
  def acuity_rescheduled
    appointment = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    a = Appointment.find_by(acuity_id: appointment['id'])
    a.update_attributes(
      start_time: appointment['date'] + " " + appointment['time'],
      end_time: appointment['date'] + " " + appointment['endTime']
    )
  end

  #when appointment is cancelled
  def acuity_canceled
    appointment = JSON.parse(AcuityService.get_client.get(path:"/api/v1/appointments/#{params['id']}").body)
    a = Appointment.find_by(acuity_id: appointment['id'])
    a.cancel!
  end
  
end