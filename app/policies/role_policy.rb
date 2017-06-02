class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    moderator?
  end
  
  def update?
    moderator?
  end

  def destroy?
    admin?
  end
end
