class ProviderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user_present?
  end

  def show?
    owner_or_admin?
  end
  
  def edit?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

end
