class HelpersController < ApplicationController
  def index
    @appointment_categories = AppointmentCategory.published.by_priority
  end
end
