class UserCompletion
  attr_accessor :user
  def initialize(user)
    @user = user
  end

  def percent_complete
    percent = 0
    percent += 10 if user.username.present?

    percent += 10 if user.location.present?

    percent += 10 if user.bio.present?

    percent += 10 if user.avatar_stored?

    percent += 10 if user.roles.any?

    percent += 10 if user.skills.count > 4

    percent += 10 if user.projects.count > 2

    percent += 10 if user.milestones.count > 4

    percent += 10 if user.website_url.present? || user.linkedin_url.present? || user.twitter_url.present? || user.dribbble_url.present? || user.facebook_url.present? || user.github_url.present? || user.medium_url.present?

    return percent
  end
end