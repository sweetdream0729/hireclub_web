class OnboardingController < ApplicationController
  include Wicked::Wizard
  before_action :sign_up_required
  layout "minimal"

  steps :username, :location, :roles

  def show
    @user = current_user
    case step
    when :roles
      unless @user.user_roles.any?
        @user.user_roles.build
      end
    end
    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    render_wizard @user
  end

  def finish_wizard_path
    if current_user.onboarded?
      user_path(current_user)
    else
      onboarding_path(:username)
    end
  end

  def user_params
    params.require(:user).permit(:name, :username, :location_id, user_roles_attributes: [:id, :role_id])
  end
end
