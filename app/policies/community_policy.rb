class CommunityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    admin?
  end
  
  def update?
    admin?
  end

  def destroy?
    admin?
  end
end
