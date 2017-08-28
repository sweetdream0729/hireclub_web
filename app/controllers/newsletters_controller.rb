class NewslettersController < ApplicationController
  before_action :sign_up_required
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

  # GET /newsletters
  def index
    @newsletters = Newsletter.all
  end

  # GET /newsletters/1
  def show
    render "newsletter_mailer/newsletter", layout: 'mailer'
  end

  # GET /newsletters/new
  def new
    @newsletter = Newsletter.new
  end

  # GET /newsletters/1/edit
  def edit
  end

  # POST /newsletters
  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save
      redirect_to @newsletter, notice: 'Newsletter was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /newsletters/1
  def update
    if @newsletter.update(newsletter_params)
      redirect_to @newsletter, notice: 'Newsletter was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /newsletters/1
  def destroy
    @newsletter.destroy
    redirect_to newsletters_url, notice: 'Newsletter was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newsletter
      @newsletter = Newsletter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def newsletter_params
      params.require(:newsletter).permit(:name, :campaign_id, :subject, :preheader, :html)
    end
end
