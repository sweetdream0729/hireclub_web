class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page])
  end

  def show
    set_user
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
