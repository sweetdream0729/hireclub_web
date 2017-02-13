class SearchController < ApplicationController
  def index
    query = params[:q]
    page = params[:page]
    @results = PgSearch.multisearch(query).page(page).per(10)
  end
end
