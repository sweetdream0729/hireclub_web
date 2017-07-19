require 'rails_helper'

RSpec.describe AcuityService do

  it "should get appointment types" do
    appointment_types = AcuityService.appointment_types
    puts appointment_types.inspect
  end

  it "should get appointments",focus: true do
    appointments = AcuityService.appointments
    puts appointments.inspect
  end
end