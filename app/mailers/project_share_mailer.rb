class ProjectShareMailer < ApplicationMailer

  def project_shared(project_share)
    set_project_share(project_share)
    if @project_share.project.private
      @subject = "#{@user.display_name} shared a private project with you"
    else
      @subject = "#{@user.display_name} shared a project with you"
    end
    
    @project_share_url = get_utm_url url_for(@project_share)

    mail(to: @project_share.input, subject: @subject, reply_to: @project_share.user.email)
  end

  def set_project_share(project_share)
    @project_share = ProjectShare.find(project_share.id)
    @user = @project_share.user
    @project = @project_share.project

    if @project_share.present?
      set_campaign(ProjectShareCreateActivity::KEY)
      add_metadata(:project_share_id, @project_share.id)
      add_metadata(:user_id, @user.try(:id))
    end
  end
end
