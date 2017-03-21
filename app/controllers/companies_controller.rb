class CompaniesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /companies
  def index
    scope = Company.all
    if params[:sort_by] == "alphabetical"
      scope = scope.alphabetical
    elsif params[:sort_by] == "oldest"
      scope = scope.oldest
    else
      scope = scope.recent
    end

    if params[:query]
      scope = scope.search_by_name(params[:query])
    end

    @companies = scope.page(params[:page]).per(10)

    respond_to do |format|
      format.json { render json: @companies }
      format.html
    end
  end

  # GET /companies/1
  def show
    impressionist(@company)
  end

  def refresh
    if @company.refresh
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
    @company.added_by = current_user

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
        :avatar, :retained_avatar, :remove_avatar, :avatar_url, :tags_list,
        :logo, :retained_logo, :remove_logo, :avatar_logo)
    end
end
