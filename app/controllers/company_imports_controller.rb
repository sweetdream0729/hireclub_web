class CompanyImportsController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    facebook_url = params[:company][:facebook_url]
    @company = Company.import_facebook_url(facebook_url)
    redirect_to @company
  end
end
