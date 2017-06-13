class JobScore < ApplicationRecord
  belongs_to :user
  belongs_to :job

  # Validations
  validates :user, presence: true
  validates :job, presence: true
  validates :user_id, uniqueness: { scope: :job_id }
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  def role_match?
    self.user.user_roles.each do |role|
      return true if role.name === self.job.name 
    end
    false
  end

  def update_score
    return if user.nil? || job.nil?
    new_score = 0

    new_score = calc_skills(new_score)
    new_score = calc_roles(new_score)
    
    self.score = [new_score,0].max
    self.save
  end

  def calc_skills(score)
    # Add user_skill.years to score
    # minimum score of 1 per matching skill
    
    job.skills.each do |skill_name|
      skill = Skill.where(name: skill_name)
      next if skill.nil?

      user_skill = user.user_skills.where(skill: skill).first
      if user_skill
        increment = [user_skill.years,1].max
        score += increment
      end
    end
    return score
  end

  def calc_roles(score)
    # Add 5 if any role matches
    if user.roles.include?(job.role)
      score += 5
    end

    return score
  end
end
