class CompanyPolicy < ApplicationPolicy
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

  def refresh?
    moderator?
  end

  def import?
    moderator?
  end

  def follow?
    true
  end

  def unfollow?
    user_present?
  end
end
