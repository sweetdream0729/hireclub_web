class AssigneePolicy < ApplicationPolicy

  def create?
    return false if user.nil?
    Pundit.policy(user, record.appointment).manage?
  end

end