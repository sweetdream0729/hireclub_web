class StoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.stories
      else
        scope.published
      end
    end
  end

  def show?
    return true if record.published?
    user.present? && (record.user == user || user.is_admin)
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

  def publish?
    owner_or_admin?
  end
end
