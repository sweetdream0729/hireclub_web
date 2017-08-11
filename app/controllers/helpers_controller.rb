class HelpersController < ApplicationController
  def index
    @appointment_categories = AppointmentCategory.by_priority
    @appointment_types = AppointmentType.by_priority
  end
end
