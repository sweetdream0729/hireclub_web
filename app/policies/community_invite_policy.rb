class CommunityInvitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return false if user.nil?
    record.sender == user || record.user == user || user.is_admin
  end

  def create?
    user_present?
  end
  
  def update?
    sender_or_admin?
  end

  def destroy?
    sender_or_admin?    
  end

  def sender_or_admin?
    return false if user.nil?
    record.sender == user || user.is_admin
  end
end
