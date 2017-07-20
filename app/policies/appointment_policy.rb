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
    owner_or_admin?
  end
  
  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end

  def refresh?
    admin?
  end

  def complete?
    return false if user.nil?
    return true if user.is_admin && record.completable?
  end
end
