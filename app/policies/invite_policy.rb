class InvitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def create?
    user_present?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end
end
