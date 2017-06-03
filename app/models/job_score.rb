class JobScore < ApplicationRecord
  belongs_to :user
  belongs_to :job

  # Validations
  validates :user, presence: true
  validates :job, presence: true
  validates :user_id, uniqueness: { scope: :job_id }
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  def update_score
    return if user.nil? || job.nil?
    puts "update_score"
    new_score = 0
    job.skills.each do |skill_name|
      
      skill = Skill.where(name: skill_name)
      next if skill.nil?

      puts "   job skill: #{skill_name}"
      user_skill = user.user_skills.where(skill: skill).first
      if user_skill
        increment = [user_skill.years,1].max
        puts "  increment: #{increment}"
        new_score += increment
      end
    end
    
    self.score = [new_score,0].max
    self.save
  end
end
