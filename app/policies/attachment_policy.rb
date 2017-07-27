class AttachmentPolicy < ApplicationPolicy

  def create?
    return false if user.nil?
    Pundit.policy(user, record.attachable).manage?
  end

  def destroy?
    return false if user.nil?
    Pundit.policy(user, record.attachable).manage?
  end
end
