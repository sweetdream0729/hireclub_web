class ProvidersController < ApplicationController
  before_action :sign_up_required
  after_action :verify_authorized, except: [:index, :new, :update]
  before_action :set_provider, only: [:show, :edit, :update]

  def index
    unless current_user.is_admin
      redirect_to new_provider_path
    end

    @providers = Provider.by_recent.page(params[:page])
  end

  def new
    if current_user.is_provider?
      redirect_to provider_path(current_user.provider)
    else
      @provider = Provider.new(user: current_user)
      authorize @provider
    end
  end

  def create
  	create_provider = Provider::CreateProvider.new(current_user, provider_params, request.remote_ip)
  	@provider = create_provider.call
    authorize @provider

  	if @provider.persisted?
  		redirect_to @provider, notice: "Add Your Bank Account"
  	else
  		render :new
    end
  end

  def edit
    authorize @provider
  end

  def update
    if @provider.update(provider_params)
      redirect_to @provider, notice: 'Provider was successfully updated.'
    else
      render :edit
    end
  end

  def show
    authorize @provider
  end

  private

    def set_provider
      @provider = Provider.find(params[:id])
    end

    def provider_params
      params.require(:provider).permit(:first_name, :last_name, :phone,
       :ssn, :date_of_birth, :address_line_1, :address_line_2, :city,
       :state, :country, :postal_code, :id_proof, :retained_id_proof, :acuity_calendar_id)
    end
end
