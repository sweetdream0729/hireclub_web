class SkillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    moderator?
  end

  def create?
    user_present?
  end

  def update?
    moderator?
  end

  def destroy?
    admin?
  end
end
