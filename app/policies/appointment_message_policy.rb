class AppointmentMessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    return false if user.nil?
    record.appointment.user == user || user.is_admin || record.appointment.assignees.where(user: user).exists?
  end

  def destroy?
    owner_or_admin?
  end
end
