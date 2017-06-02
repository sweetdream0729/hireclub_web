class ReviewRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return false if user.nil?
    user.is_reviewer || user.is_admin || record.user == user
  end

  def create?
    user_present?
  end
  
  def update?
    return false if user.nil?
    user.is_reviewer || user.is_admin || record.user == user
  end

  def destroy?
    owner_or_admin?
  end
end
