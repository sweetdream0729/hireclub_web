class CommunityInvitesController < ApplicationController

  def new
    set_community
    @community_invite = CommunityInvite.new(community: @community)
    authorize @community_invite
  end

  def create
    @community_invite = CommunityInvite.new(community_invite_params)
    authorize @community_invite
    @community = @community_invite.community
    @community_invite.sender = current_user

    if @community_invite.save
      redirect_to @community_invite.community, notice: "Invite sent to #{@community_invite.user.display_name}"
    else
      render :new
    end
  end

  def show
    set_community_invite
    @community = @community_invite.community
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    def set_community_invite
      @community_invite = CommunityInvite.friendly.find(params[:id])
      authorize @community_invite
    end

    # Only allow a trusted parameter "white list" through.
    def community_invite_params
      params.require(:community_invite).permit(:user_id, :community_id)
    end
end