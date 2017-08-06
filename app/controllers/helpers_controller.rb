class HelpersController < ApplicationController
  def index
    @appointment_types = AppointmentType.by_priority
  end
end
