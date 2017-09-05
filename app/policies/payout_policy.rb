class PayoutPolicy < ApplicationPolicy

  def create?
    return false if user.nil?
    return true if user.is_admin
  end

  def new?
  	create?
  end

end