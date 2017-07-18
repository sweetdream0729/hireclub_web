class JobScore < ApplicationRecord
  belongs_to :user
  belongs_to :job

  # Scopes
  scope :by_score,            -> { order(score: :desc) }
  scope :greater_than_zero,   -> { where("score > ? ", 0)}

  # Validations
  validates :user, presence: true
  validates :job, presence: true
  validates :user_id, uniqueness: { scope: :job_id }
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  def update_score
    return if user.nil? || job.nil?
    
    skills_score = calc_skills
    roles_score = calc_roles
    projects_score = calc_projects
    
    new_score = skills_score + roles_score + projects_score

    if new_score > 0
      location_score = calc_location
      new_score += location_score

      remote_score = calc_remote
      new_score += remote_score
    end
    
    self.score = [new_score,0].max
    self.save
  end

  def calc_skills
    skills_score = 0
    # Add user_skill.years to score
    # minimum score of 1 per matching skill

    job.skills.each do |skill_name|
      skill = Skill.where(name: skill_name)
      next if skill.nil?

      user_skill = user.user_skills.where(skill: skill).first
      if user_skill
        increment = [user_skill.years,1].max
        skills_score += increment
      end
    end
    return skills_score
  end

  def calc_roles
    roles_score = 0
    # Add 5 if any role matches
    if user.roles.include?(job.role)
      roles_score += 5
    end
    return roles_score
  end

  #iterate through the job's skills and total user's project skills; 
  #increment score by one at most for each skill found on a unique project

  def calc_projects
    projects_score = 0
    job.skills.each do |skill_name|
      skill = Skill.search_by_exact_name(skill_name).first
      next if skill.nil?
      matching_projects = user.projects.with_any_skills(skill.name)
      projects_score += matching_projects.count
    end
    return projects_score
  end

  def calc_location
    location_score = 0
    if job.location == user.location
      location_score = 5
    elsif user.location.present?
      distance = user.location.distance_to([job.location.latitude, job.location.longitude])
      if distance <= 120
        location_score = 3
      end
    end

    return location_score
  end

  def calc_remote
    return 3 if job.remote && user.open_to_remote
    return 0
  end

end
