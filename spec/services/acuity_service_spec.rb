require 'rails_helper'

RSpec.describe AcuityService do

  it "should get_appointment_types" do
    appointment_types = AcuityService.get_appointment_types
    puts appointment_types.inspect
  end

  it "should get_appointments" do
    appointments = AcuityService.get_appointments
    puts appointments.inspect
  end

  it "should refresh_appointment_types" do
    appointment_types = AcuityService.refresh_appointment_types
    puts appointment_types.inspect
  end

  it "should refresh_appointments" do
    appointments = AcuityService.refresh_appointments
    puts appointments.inspect
  end
end