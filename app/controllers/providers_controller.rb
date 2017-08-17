class ProvidersController < ApplicationController
  before_action :sign_up_required
  def new
    if current_user.is_provider?
      redirect_to current_user.provider
    else
  	 @provider = Provider.new
    end
  end

  def create
  	create_provider = Provider::CreateProvider.new(current_user, provider_params, request.remote_ip)
  	@provider = create_provider.call
  	if !@provider.id.nil?
  		redirect_to @provider, notice: "Your are a provider"
  	else
  		render :new
    end
  end

  def show
  	@provider = Provider.find_by(user_id: current_user.id)
  end

  private
    def provider_params
      params.require(:provider).permit(:first_name, :last_name, :phone,
       :ssn_last_4, :date_of_birth, :address_line_1, :address_line_2, :city,
       :state, :country, :postal_code)
  end
end
