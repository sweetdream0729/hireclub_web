class UsersController < ApplicationController
  def index
    scope = User.all
    if params[:sort_by] == "alphabetical"
      scope = scope.alphabetical
    elsif params[:sort_by] == "oldest"
      scope = scope.oldest
    else
      scope = scope.recent
    end
    @users = scope.page(params[:page]).per(10)
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
