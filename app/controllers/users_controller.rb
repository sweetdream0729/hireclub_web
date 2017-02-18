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

    @user_skills = @user.user_skills.by_position
    @first_skills = @user_skills.limit(5)
    @rest_skills = @user_skills.offset(5)
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
