class UserSkillListener
  def update_user_skill(user_skill)
    user = user_skill.user
    return unless user.present?

    user.update_years_experience

    user.reload
    if user.user_skills.count >= 5
      Badge.reward_skill_badge(user)
    end
  end
end