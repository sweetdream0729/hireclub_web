class HelpersController < ApplicationController
  def index
    @appointment_categories = AppointmentCategory.published.by_priority
    @appointment_types = AppointmentType.by_priority
  end
end
