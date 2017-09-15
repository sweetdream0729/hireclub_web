class NewslettersController < ApplicationController
  before_action :sign_up_required
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy, :preview, :publish]
  after_action :verify_authorized, except: [:index]

  # GET /newsletters
  def index
    redirect_to root_path unless current_user.is_admin
    @newsletters = Newsletter.by_recent
  end

  # GET /newsletters/1
  def show
    @user = current_user
    render "newsletter_mailer/newsletter", layout: 'mailer'
  end

  def preview
    @user = current_user
    NewsletterMailer.newsletter(@newsletter, @user).deliver_now
    redirect_to newsletters_path, notice: "Newsletter preview sent to #{current_user.email}"
  end

  def publish
    @newsletter.publish!(current_user)
    @newsletter.reload
    redirect_to newsletters_path, notice: "Newsletter #{@newsletter.campaign_id} sent to #{@newsletter.email_list.members_count} users in #{@newsletter.email_list.name}"
  end

  # GET /newsletters/new
  def new
    @newsletter = Newsletter.new
    authorize @newsletter
  end

  # GET /newsletters/1/edit
  def edit
  end

  # POST /newsletters
  def create
    @newsletter = Newsletter.new(newsletter_params)
    authorize @newsletter

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
      authorize @newsletter
    end

    # Only allow a trusted parameter "white list" through.
    def newsletter_params
      params.require(:newsletter).permit(:name, :campaign_id, :subject, :preheader, :email_list_id, :html)
    end
end
