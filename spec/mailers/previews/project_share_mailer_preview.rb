# Preview all emails at http://localhost:3000/rails/mailers/project_share
class ProjectShareMailerPreview < ActionMailer::Preview
  def project_shared
    project_share = ProjectShare.last
    ProjectShareMailer.project_shared(project_share)
  end
end
