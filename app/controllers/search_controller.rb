class SearchController < ApplicationController
  def index
    query = params[:q]
    page = params[:page]
    @companies = Company.search_by_name(query).page(page).per(10)
    @users = User.search_by_name(query).page(page).per(10)
  end
end
