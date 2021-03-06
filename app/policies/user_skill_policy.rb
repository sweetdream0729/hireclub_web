class UserSkillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.user_skills
      else
        scope.none
      end
    end
  end

  def create?
    user_present?
  end
  
  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end
end
