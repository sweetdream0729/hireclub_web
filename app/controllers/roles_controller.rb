class RolesController < ApplicationController
  after_action :verify_authorized, except: [:index]
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  def index
    @roles = Role.by_name.page(params[:page]).per(20)
  end

  # GET /roles/1
  def show
    @users = @role.users.page(params[:page])
  end

  # GET /roles/new
  def new
    @role = Role.new
    authorize @role
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    authorize @role

    if @role.save
      redirect_to @role, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      redirect_to @role, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
    redirect_to roles_url, notice: 'Role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.friendly.find(params[:id])
      authorize @role
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :slug, :users_count)
    end
end
