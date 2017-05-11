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

    @milestones = @user.milestones.by_newest
    @first_milestones = @milestones.limit(5)
    @rest_milestones = @milestones.offset(5)

    @user_skills = @user.user_skills.by_position
    @first_skills = @user_skills.limit(5)
    @rest_skills = @user_skills.offset(5)

    if @user == current_user
      @user_completion = UserCompletion.new(@user)
    end
  end

  def print
    set_user
    impressionist(@user)

    @milestones = @user.milestones.printable.by_newest
    render layout: "print"
  end

  def follow
    set_user

    unless user_signed_in?
      # take us to sign up if we aren't logged in
      store_location(follow_user_path(@user))
      redirect_to(new_user_registration_path, format: :html) and return
    end

    current_user.follow @user
    @user.reload
    
    respond_to do |format|
      format.js { render :follow}
      format.html { redirect_to @user }
    end
  end

  def unfollow
    set_user
    
    current_user.stop_following @user
    @user.reload
    
    respond_to do |format|
      format.js { render :follow}
      format.html { redirect_to @user }
    end
  end


  def username
    username = (params[:q] || "").downcase
    scope = User.where('lower(username) = ?', username.downcase)
    
    if user_signed_in?
      scope = scope.where.not(id: current_user.id)
    end

    available = !scope.exists?
    
    hash = {
      :available => available,
      :username => username
    }

    respond_to do |format|
      format.json { render :json => hash.to_json }
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
