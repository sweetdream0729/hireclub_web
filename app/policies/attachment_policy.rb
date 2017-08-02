class AttachmentPolicy < ApplicationPolicy

  def create?
    return false if user.nil?
    record.attachable.user == user || user.is_admin || record.attachable.assignees.where(user: user).exists?
  end

  def destroy?
    owner_or_admin?
  end
end
