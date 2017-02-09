class UserSkillListener
  def update_user_skill(user_skill)
    user_skill.user.update_years_experience if user_skill.user
  end
end