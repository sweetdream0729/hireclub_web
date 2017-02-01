class OnboardingController < ApplicationController
  include Wicked::Wizard

  steps :username

  def show
    @user = current_user
    # case step
    # when :find_friends
    #   @friends = @user.find_friends
    # end
    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    render_wizard @user
  end

  def user_params
    params.require(:user).permit(:name, :username)
  end
end
