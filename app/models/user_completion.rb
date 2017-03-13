class UserCompletion
  attr_accessor :user, :link, :percent

  def initialize(user)
    @user = user
    @percent = self.percent_complete
    @link = self.next_link
  end

  def percent_complete
    #started with 10% until last user_completion task decided
    @percent = 10

    @percent += 10 if user.username.present?

    @percent += 10 if user.location.present?

    @percent += 10 if user.bio.present?

    @percent += 10 if user.avatar_stored?

    @percent += 10 if user.roles.any?

    @percent += 10 if user.skills.count > 4

    @percent += 10 if user.projects.count > 2

    @percent += 10 if user.milestones.count > 4

    @percent += 10 if user.website_url.present? || user.linkedin_url.present? || user.twitter_url.present? || user.dribbble_url.present? || user.facebook_url.present? || user.github_url.present? || user.medium_url.present?

    @percent
  end

  def next_step
    return "Set Username" if user.username.blank?
    return "Set Location" if user.location.blank?
    return "Complete Bio" if user.bio.blank?
    return "Add avatar" if user.avatar.blank?
    return "Add roles" if user.roles.blank?
    return "Add 5 or more skills" if user.skills.count <= 4
    return "Add 3 or more projects" if user.projects.count <= 2
    return "Add 5 or more milestones" if user.milestones.count <= 4
    return "Add website url" if user.website_url.blank?
    return "Complete Profile"
  end

  def next_link
    @link = "/settings" if self.next_step == "Set Username" || self.next_step == "Set Location" || self.next_step == "Complete Bio" || self.next_step == "Add avatar" || self.next_step == "Add website url"
    @link = "/user_roles/new" if self.next_step == "Add roles"
    @link = "/user_skills/new" if self.next_step == "Add 5 or more skills"
    @link = "/#{@user.id}/projects/new" if self.next_step == "Add 3 or more projects"
    @link = "/milestones/new" if self.next_step == "Add 5 or more milestones"
    @link = "#" if @percent == 100
    @link
  end


end

