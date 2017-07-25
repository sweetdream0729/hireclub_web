class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.appointments
      else
        scope.none
      end
    end
  end

  def create?
    user_present?
  end

  def show?
    return false if user.nil?
    return true if user.is_admin || record.user == user || record.assignees.where(user: user).exists?
  end
  
  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end

  def refresh?
    return false if user.nil?
    return true if user.is_admin || record.assignees.where(user: user).exists?
  end

  def manage?
    refresh?
  end

  def complete?
    return false if user.nil?
    return true if record.completable? && (user.is_admin || record.assignees.where(user: user).exists?)
  end
end
