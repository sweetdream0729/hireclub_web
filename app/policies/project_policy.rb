class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.projects
      else
        scope.none
      end
    end
  end

  def show?
    # admins can always see private projects
    return true if user.present? && user.is_admin
    Project.viewable_by(user, record.user).where(id: record.id).exists?
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
