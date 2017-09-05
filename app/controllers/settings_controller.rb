class SettingsController < ApplicationController
  before_action :sign_up_required, except: [:unsubscribe, :resubscribe]
  before_action :set_user

  def index
  end

  def status
  end

  def account
  end

  def links

  end

  def notifications

  end

  def payments
    @payments = current_user.payments
  end

  def update
    # What page to return to
    session[:return_to] = request.referer
    session[:return_to] ||= settings_path
    
    if @user.update_without_password(user_params)
      # Sign in the user bypassing validation in case his password changed
      bypass_sign_in @user

      redirect_to session.delete(:return_to), notice: 'Settings Updated'
    else
      render :account
    end
  end

  def unsubscribe
    data = User.read_access_token(params[:signature])
    @preference = data[:preference]
    if data && data[:user_id] && data[:preference]
      @user = User.find(data[:user_id])
      @user.update_preference(data[:preference], data[:value])

      if data[:preference] == "unsubscribe_all"
        @mail_type = "all"
      else
        @mail_type = data[:preference].split('_')[2..-1].join(" ")
      end

      render :layout => 'minimal'
    else
      redirect_to new_user_session_path
    end

  end

  def resubscribe
    data = User.read_access_token(params[:signature])
    @preference = data[:preference]
    if data && data[:user_id] && data[:preference]
      @user = User.find(data[:user_id])
      @user.update_preference(data[:preference], data[:value])

      @mail_type = data[:preference].split('_')[2..-1].join(" ")

      render :layout => 'minimal'
    else
      redirect_to new_user_session_path
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:username, :name, :email, :password, :avatar, :retained_avatar, :remove_avatar, 
      :location_id, :company_id, :bio, :timezone,
      :is_available, :is_hiring, :is_reviewer,
      :open_to_remote, :open_to_full_time, :open_to_part_time, :open_to_contract, :open_to_internship, :open_to_relocation, :open_to_new_opportunities,
      :is_us_work_authorized, :requires_us_visa_sponsorship,
      :website_url, :twitter_url, :dribbble_url, :github_url, :medium_url, :facebook_url, :linkedin_url, :instagram_url, :imdb_url,
      preference_attributes: [:email_on_follow, :email_on_comment, :email_on_mention, :email_on_unread, :email_on_job_post, :email_on_event_publish, :unsubscribe_all])
    end
end
