class CompaniesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /companies
  def index
    @companies = Company.by_name.page(params[:page]).per(10)
  end

  # GET /companies/1
  def show
  end

  def refresh
    if @company.facebook_url.present?
      Company.import_facebook_url(@company.facebook_url) 
      notice = "Company Refreshed"
    end
    redirect_to @company, notice: notice
  end

  # GET /companies/new
  def new
    @company = Company.new
    authorize @company
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    authorize @company

    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.friendly.find(params[:id])
      authorize @company
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :slug, :twitter_url, :facebook_url, :instagram_url, :angellist_url, :website_url, :tagline,
        :avatar, :retained_avatar, :remove_avatar, :avatar_url,
        :logo, :retained_logo, :remove_logo, :avatar_logo)
    end
end
