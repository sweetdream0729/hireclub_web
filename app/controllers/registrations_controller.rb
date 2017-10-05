class RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:name, :email, :password)
  end

  #devise sign_up method overrided to update the invite

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
    update_invite(resource)
  end

  def account_update_params
    params.require(:user).permit(:username, :name, :email, :password, :avatar, :retained_avatar, :remove_avatar, 
      :location_id, :company_id, :bio,
      :is_available, :is_hiring, :is_reviewer,
      :open_to_remote, :open_to_full_time, :open_to_part_time, :open_to_contract, :open_to_internship, :open_to_relocation, :open_to_new_opportunities,
      :is_us_work_authorized, :requires_us_visa_sponsorship,
      :website_url, :twitter_url, :dribbble_url, :github_url, :medium_url, :facebook_url, :linkedin_url, :instagram_url, :imdb_url)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def update_invite(resource)
    # if user invited to hireclub then update recipient_id for invite
    if cookies[:invite_id].present?
      invite = Invite.find(cookies[:invite_id])
      invite.recipient_id = resource.id
      invite.save
      cookies.delete :invite_id
    end
  end
end
