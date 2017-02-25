class LikesController < ApplicationController
  #after_action :verify_authorized, except: [:index]
  before_action :set_like, only: [:show, :destroy]

  # GET /likes
  def index
    scope = Like.recent
    @likes = scope.page(params[:page]).per(10)
  end

  # GET /likes/1
  def show
    
  end

  # GET /likes/new
  def new
    @like = Like.new
    #authorize @like
  end

  # POST /likes
  def create
    @like = Like.new(like_params)
    #authorize @like

    if @like.save
      redirect_to @like, notice: 'Like was successfully created.'
    else
      render :new
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
    redirect_to likes_url, notice: 'Like was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
      #authorize @like
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      params.require(:like).permit(:user_id, :likeable_id, :likeable_type)
    end
end
