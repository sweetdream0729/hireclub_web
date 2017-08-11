class ProvidersController < ApplicationController
  before_action :sign_up_required
  def new
  	@provider = Provider.new
  end

  def create
  	create_provider = Provider::CreateProvider.new(current_user, params[:provider][:country], request.remote_ip)
  	@provider = create_provider.call
  	if @provider
  		redirect_to @provider, notice: "Your are a provider"
  	else
  		render :new
    end
  end

  def show
  	@provider = Provider.find_by(user_id: current_user.id)
  end
end
