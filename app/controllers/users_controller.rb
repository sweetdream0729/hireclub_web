class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    set_user
    impressionist(@user)
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
