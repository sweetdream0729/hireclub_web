class JobPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
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

  def suggest_skill?
    owner_or_admin?
  end

  def refer?
    owner_or_admin?
  end
end
