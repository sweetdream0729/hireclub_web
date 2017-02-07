class LocationsController < ApplicationController
  def index
    @locations = Location.search_by_name(params[:query]).page(params[:page])
    render json: @locations
  end
end