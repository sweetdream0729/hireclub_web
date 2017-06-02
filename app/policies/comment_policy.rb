class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return true
  end

  def create?
    user_present?
  end
  
  def update?
    return false if user.nil?
    record.user == user || user.is_admin
  end

  def destroy?
    return false if user.nil?
    record.user == user || user.is_admin || record.commentable.user == user
  end

  def like?
    user_present?
  end

  def unlike?
    user_present?
  end
end
