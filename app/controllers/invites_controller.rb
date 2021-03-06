class InvitesController < ApplicationController
  before_action :sign_up_required, except: [:show]
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index]

  # GET /invites
  def index
    @invites = current_user.invites.by_recent.page(params[:page]).per(20)
  end

  # GET /invites/1
  def show
    impressionist(@invite)
    @user = @invite.user
    @invite.mark_viewed!(current_user)
    @bounced = @invite.activities.where(key: InviteBounceActivity::KEY).exists?
    
    if current_user.nil? || (!current_user.is_admin && current_user != @user)
      cookies[:invite_id] = @invite.id
      redirect_to user_path(@invite.user)
    end
  end

  # GET /invites/new
  def new
    @invite = Invite.new
    authorize @invite
  end

  # POST /invites
  def create
    @invite = current_user.invites.build(invite_params)
    authorize @invite
    if @invite.save
      InviteMailer.invite_created(@invite).deliver_later
      redirect_to @invite, notice: "Invite sent to #{@invite.input}."
    else
      render :new
    end
  end

  # DELETE /invites/1
  def destroy
    @invite.destroy
    redirect_to invites_url, notice: 'Invite was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.friendly.find(params[:id])
      authorize @invite
    end

    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:input, :text)
    end
end
