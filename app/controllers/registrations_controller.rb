class RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:email, :password)
  end

  def account_update_params
    params.require(:user).permit(:username, :name, :email, :password, :avatar, :retained_avatar, :remove_avatar)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end