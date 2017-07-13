class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :members]

  # GET /communities
  def index
    scope = Community.all

    if params[:sort_by] == "popular"
      scope = scope.by_members
    elsif params[:sort_by] == "alphabetical"
      scope = scope.alphabetical
    elsif params[:sort_by] == "oldest"
      scope = scope.oldest
    else
      scope = scope.recent
    end

    if params[:query]
      scope = scope.search_by_name(params[:query])
    end

    @communities = scope.page(params[:page]).per(20)
  end

  # GET /communities/1
  def show
    authorize @community
    impressionist(@community)
    @community.join_pending_invites(current_user)
    @posts = @community.posts.recent.page(params[:page]).per(10)
  end

  def members
    scope = @community.community_members
    @members = scope.page(params[:page]).per(10)
  end

  def join
    set_community

    unless user_signed_in?
      # take us to sign up if we aren't logged in
      store_location(join_community_path(@community))
      redirect_to(new_user_registration_path, format: :html) and return
    end

    current_user.join_community(@community)
    @community.reload

    respond_to do |format|
      format.js { render :join}
      format.html { redirect_to @community }
    end
  end

  def leave
    set_community

    current_user.leave_community(@community)
    @community.reload

    respond_to do |format|
      format.js { render :join}
      format.html { redirect_to @community }
    end
  end

  # GET /communities/new
  def new
    @community = Community.new
    authorize @community
  end

  # GET /communities/1/edit
  def edit
    authorize @community
  end

  # POST /communities
  def create
    @community = Community.new(community_params)
    authorize @community

    if @community.save
      redirect_to @community, notice: 'Community was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /communities/1
  def update
    authorize @community
    if @community.update(community_params)
      redirect_to @community, notice: 'Community was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /communities/1
  def destroy
    authorize @community
    @community.destroy
    redirect_to communities_url, notice: 'Community was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def community_params
      params.require(:community).permit(:name, :slug, :description,
        :avatar, :retained_avatar, :remove_avatar, :avatar_url)
    end
end
