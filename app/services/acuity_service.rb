class AcuityService
  BASE_URL = "https://acuityscheduling.com/api/v1"
  
  def self.get_client
    # @connection ||=  Excon.new( BASE_URL, 
    #                             user: Rails.application.secrets.acuity_user_id, 
    #                             password: Rails.application.secrets.acuity_api_key,
    #                             debug_response: true)

    @connection ||= Excon.new("https://13980751:ebf8d901f44bf9a786cc266474087469@acuityscheduling.com")
  end

  def self.appointment_types
    JSON.parse(self.get_client.get(path:"/api/v1/appointment-types").body) rescue []
  end

  def self.get_appointments
    JSON.parse(self.get_client.get(path:"/api/v1/appointments").body) rescue []
  end

end