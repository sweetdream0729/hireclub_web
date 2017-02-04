class UsersController < ApplicationController
  def show
    set_user
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
